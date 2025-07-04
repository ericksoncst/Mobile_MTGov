FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    ANDROID_HOME=/opt/android-sdk \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    PATH="${JAVA_HOME}/bin:${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

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

# Optimized wait script (3-minute timeout)
RUN echo '#!/bin/bash\n\
set -e\n\
timeout 180 bash -c '\''\n\
  echo "⏳ Waiting for ADB (max 3m)..."\n\
  until adb devices | grep -q "emulator"; do sleep 5; done\n\
  \n\
  echo "⚙️ Checking boot status..."\n\
  until adb shell getprop sys.boot_completed | grep -q "1"; do\n\
    adb shell input keyevent 82\n\
    sleep 10\n\
  done\n\
  \n\
  echo "🔍 Verifying system stability..."\n\
  adb shell pm list packages >/dev/null\n\
'\''\n\
\n\
if [ $? -eq 0 ]; then\n\
  echo "✅ Emulator ready in $(($SECONDS/60))m$(($SECONDS%60))s"\n\
else\n\
  echo "❌ Boot failed"\n\
  echo "=== Device Info ==="\n\
  adb devices -l\n\
  echo "=== System Props ==="\n\
  adb shell getprop | grep -E "boot|sys"\n\
  exit 1\n\
fi' > /wait_for_emulator.sh && \
chmod +x /wait_for_emulator.sh

# Copy APK with validation
WORKDIR /app
COPY . .
COPY ./apps/app.apk /tmp/app.apk
RUN if [ ! -f /tmp/app.apk ]; then \
      echo "❌ APK missing"; exit 1; \
    elif ! unzip -t /tmp/app.apk >/dev/null 2>&1; then \
      echo "❌ Invalid APK"; file /tmp/app.apk; exit 1; \
    else \
      mkdir -p /app/apps && mv /tmp/app.apk /app/apps/app.apk; \
    fi

# Python environment
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Startup command
CMD ["/bin/bash", "-c", "\
    echo '🚀 Starting emulator...' && \
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator \
      -no-audio \
      -no-window \
      -no-snapshot \
      -memory 2048 \
      -gpu swiftshader_indirect \
      -ports 5554,5555 &> /app/emulator.log & \
    \n\
    echo '⏳ Waiting for emulator...' && \
    /wait_for_emulator.sh && \
    \n\
    echo '💉 Installing APK...' && \
    adb install -t -g /app/apps/app.apk || { \
      echo '❌ Install failed'; \
      adb shell pm list packages; \
      exit 1; \
    } && \
    \n\
    echo '🌐 Starting Appium...' && \
    appium \
      --relaxed-security \
      --allow-insecure=apk_check \
      --base-path /wd/hub \
      --address 0.0.0.0 \
      --port 4723 &> /app/appium.log & \
    \n\
    echo '🕒 Waiting for Appium...' && \
    timeout 60 bash -c '\''\
      until curl -s http://localhost:4723/wd/hub/status | grep -q \"status\":0; do \
        sleep 5; \
      done'\'' || { \
      echo '❌ Appium failed'; \
      tail -n 50 /app/appium.log; \
      exit 1; \
    } && \
    \n\
    echo '🔍 Running tests...' && \
    source ./venv/bin/activate && \
    robot --outputdir test_results /app/test_cases"]