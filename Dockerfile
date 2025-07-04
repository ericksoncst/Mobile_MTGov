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

# Install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip -q tools.zip -d tmp && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    mv tmp/cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/ && \
    rm -rf tools.zip tmp

# Accept licenses and install SDK components
RUN mkdir -p ~/.android && touch ~/.android/repositories.cfg && \
    yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses > /dev/null && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "platform-tools" \
        "platforms;android-30" \
        "build-tools;30.0.3" && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "emulator" --channel=0 && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "system-images;android-30;google_apis;x86_64" --channel=0

# Create AVD
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager \
    create avd -n testEmulator -k "system-images;android-30;google_apis;x86_64" \
    --device "pixel_4" --force

# Install Appium and drivers
RUN npm install -g appium@2.13.0 && \
    npm install -g appium-doctor && \
    appium driver install uiautomator2

# Set working directory and copy app files
WORKDIR /app
COPY . .
COPY ./apps/app.apk /app/apps/app.apk

# Create Python environment
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Execution command
CMD ["/bin/bash", "-c", "\
    # Start emulator
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator -no-audio -no-window -no-snapshot -no-boot-anim -ports 5554,5555 & \
    emulator_pid=$! && \
    \
    echo '⏳ Waiting for emulator...' && \
    adb wait-for-device && \
    while [ \"$(adb shell getprop sys.boot_completed | tr -d '\r')\" != \"1\" ]; do \
      echo '🕐 Boot not complete yet...'; \
      sleep 5; \
    done && \
    echo '✅ Boot complete. Unlocking screen...' && \
    adb shell input keyevent 82 && \
    adb shell wm dismiss-keyguard && \
    \
    echo '⏳ Waiting a bit for system to stabilize...' && \
    sleep 20 && \
    \
    echo '🔍 Devices connected:' && \
    adb devices && \
    \
    echo '🚀 Starting Appium...' && \
    appium \
      --relaxed-security \
      --allow-insecure=adb_shell \
      --base-path /wd/hub \
      --address 0.0.0.0 \
      --port 4723 \
      --log-timestamp \
      --local-timezone \
      --log-level debug &> /app/appium.log & \
    appium_pid=$! && \
    \
    echo '⏳ Waiting for Appium (HTTP check)...' && \
    for i in {1..10}; do \
      if curl -s http://localhost:4723/wd/hub/status >/dev/null; then \
        echo '✅ Appium is ready!'; \
        break; \
      fi; \
      echo \"Attempt $i: Appium not ready yet...\"; \
      sleep 5; \
      if [ $i -eq 10 ]; then \
        echo '❌ Appium failed to start!'; \
        tail -n 50 /app/appium.log; \
        exit 1; \
      fi; \
    done && \
    \
    echo '🧪 Starting Robot tests...' && \
    source ./venv/bin/activate && \
    robot --outputdir /app/test_results /app/test_cases || true && \
    \
    echo '✅ Tests completed.' && \
    kill -9 $appium_pid $emulator_pid 2>/dev/null || true"]
