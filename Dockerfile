FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    ANDROID_HOME=/opt/android-sdk \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Set PATH in a separate RUN command to ensure variables are available
RUN echo "PATH=${JAVA_HOME}/bin:${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator" >> /etc/environment

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        python3-pip \
        python3-venv \
        android-tools-adb \
        openjdk-17-jdk \
        wget \
        unzip \
        libgl1 \
        libpulse0 \
        libx11-6 \
        libxcb1 \
        libxext6 \
        libxrender1 \
        libxtst6 \
        qemu-kvm \
        tzdata \
        file \
        netcat \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Install Android SDK (ARM64)
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip -q tools.zip -d tmp && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    mv tmp/cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/ && \
    rm -rf tools.zip tmp

# Install Android components (ARM64)
RUN mkdir -p ~/.android && touch ~/.android/repositories.cfg && \
    yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses > /dev/null && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "platform-tools" \
        "platforms;android-30" \
        "build-tools;30.0.3" && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "emulator" && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "system-images;android-30;google_apis;arm64-v8a"

# Create AVD (ARM64)
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager \
    create avd -n testEmulator -k "system-images;android-30;google_apis;arm64-v8a" \
    --device "pixel_4" --force

# Install Appium
RUN npm install -g appium@2.13.0 && \
    npm install -g appium-doctor && \
    appium driver install uiautomator2

# Create wait_for_emulator.sh
RUN cat <<'EOF' > /wait_for_emulator.sh
#!/bin/bash
set -e

echo "🚀 Starting emulator..."
${ANDROID_HOME}/emulator/emulator -avd testEmulator \
  -no-audio \
  -no-window \
  -no-snapshot \
  -memory 2048 \
  -gpu swiftshader_indirect \
  -ports 5554,5555 &> /app/emulator.log &
emulator_pid=$!

echo "⏳ Waiting for ADB connection (max 3m)..."
timeout 180 bash -c '
  until adb devices | grep -q "emulator"; do
    sleep 5
  done
' || {
  echo "❌ ADB connection failed"
  echo "=== Emulator Log ==="
  tail -n 50 /app/emulator.log
  exit 1
}

echo "⚙️ Waiting for system boot (max 3m)..."
timeout 180 bash -c '
  until adb shell getprop sys.boot_completed | grep -q "1"; do
    adb shell input keyevent 82
    sleep 10
  done
' || {
  echo "❌ System boot failed"
  echo "=== System Properties ==="
  adb shell getprop | grep -E "boot|init|sys"
  exit 1
}

echo "🔍 Verifying services (max 1m)..."
timeout 60 bash -c '
  until adb shell pm list packages >/dev/null; do
    sleep 5
  done
' || {
  echo "❌ Core services not responding"
  exit 1
}

echo "✅ Emulator ready in $(($SECONDS/60))m$(($SECONDS%60))s"
EOF

RUN chmod +x /wait_for_emulator.sh

# Copy project files
WORKDIR /app
COPY . .

# Verify and install APK
RUN mkdir -p /app/apps && \
    if [ ! -f /app/apps/app.apk ]; then \
      echo "❌ APK not found at /app/apps/app.apk"; \
      exit 1; \
    fi && \
    echo "✅ APK found (size: $(du -h /app/apps/app.apk | cut -f1))" && \
    { unzip -t /app/apps/app.apk >/dev/null 2>&1 || { \
      echo "⚠️ APK validation warning (continuing anyway)"; \
      echo "File type: $(file /app/apps/app.apk)"; \
    }; }

# Python environment
RUN python3 -m venv /app/venv && \
    . /app/venv/bin/activate && \
    pip install --upgrade pip && \
    if [ -f /app/requirements.txt ]; then \
      pip install -r /app/requirements.txt; \
    else \
      echo "⚠️ requirements.txt not found, skipping"; \
    fi

# Main entrypoint in proper JSON format
CMD ["/bin/bash", "-c", "exec /app/startup.sh"]