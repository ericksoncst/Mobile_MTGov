# Base image
FROM ubuntu:22.04

# Environment configuration
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    ANDROID_HOME=/opt/android-sdk \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    PATH="$JAVA_HOME/bin:$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator" \
    NODE_VERSION=20.x \
    APPIUM_VERSION=2.13.0 \
    EMULATOR_NAME=testEmulator \
    EMULATOR_PORT=5554

# Install system dependencies
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
        locales \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Configure locale
ENV LANG en_US.utf8

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Install Android Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip -q tools.zip -d tmp && \
    mv tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm -rf tools.zip tmp

# Accept licenses and install Android components
RUN mkdir -p ~/.android && touch ~/.android/repositories.cfg && \
    yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-30" \
        "build-tools;30.0.3" && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "emulator" && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "system-images;android-30;google_apis;x86_64"

# Create Android Virtual Device
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager \
    create avd -n ${EMULATOR_NAME} \
    -k "system-images;android-30;google_apis;x86_64" \
    --device "pixel_4" --force

# Install Appium and drivers
RUN npm install -g appium@${APPIUM_VERSION} && \
    npm install -g appium-doctor && \
    appium driver install uiautomator2 && \
    appium driver install xcuitest

# Create emulator wait script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Waiting for ADB to be ready..."\n\
adb wait-for-device\n\
echo "Waiting for emulator to fully boot..."\n\
while [ "$(adb shell getprop sys.boot_completed | tr -d '"'"'\r'"'"')" != "1" ]; do\n\
  echo "Emulator not ready yet. Sending wake event..."\n\
  adb shell input keyevent 82\n\
  sleep 5\n\
done\n\
echo "Emulator ready! Waiting additional 15 seconds for services..."\n\
sleep 15\n\
adb devices\n\
adb shell pm list packages' > /wait_for_emulator.sh && \
    chmod +x /wait_for_emulator.sh

# Setup working directory
WORKDIR /app
COPY . .

# Create Python environment
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 \
    CMD adb shell pm list packages >/dev/null || exit 1

# Main entrypoint
CMD ["/bin/bash", "-c", "\
    set -e\n\
    echo '=== Starting Test Environment ==='\n\
    \n\
    # Start emulator\n\
    echo 'Starting emulator on port ${EMULATOR_PORT}...'\n\
    ${ANDROID_HOME}/emulator/emulator \
      -avd ${EMULATOR_NAME} \
      -no-audio \
      -no-window \
      -no-boot-anim \
      -no-snapshot \
      -ports ${EMULATOR_PORT},$((${EMULATOR_PORT}+1)) &> /app/emulator.log &\n\
    emulator_pid=$!\n\
    \n\
    # Wait for emulator\n\
    /wait_for_emulator.sh\n\
    \n\
    # Start Appium\n\
    echo 'Starting Appium server...'\n\
    appium \
      --relaxed-security \
      --allow-insecure=adb_shell \
      --base-path /wd/hub \
      --address 0.0.0.0 \
      --port 4723 \
      --log-timestamp \
      --local-timezone \
      --log-level debug &> /app/appium.log &\n\
    appium_pid=$!\n\
    \n\
    # Wait for Appium\n\
    echo 'Waiting for Appium to start...'\n\
    for i in {1..10}; do\n\
      if curl -s http://localhost:4723/wd/hub/status >/dev/null; then\n\
        echo 'Appium ready!'\n\
        break\n\
      fi\n\
      echo \"Attempt \$i: Appium not ready yet...\"\n\
      sleep 5\n\
      if [ \$i -eq 10 ]; then\n\
        echo '::error::Appium failed to start!'\n\
        echo '=== Last 50 lines of Appium log ==='\n\
        tail -n 50 /app/appium.log\n\
        exit 1\n\
      fi\n\
    done\n\
    \n\
    # Run tests\n\
    echo '=== Starting Test Execution ==='\n\
    source ./venv/bin/activate\n\
    robot --outputdir test_results /app/test_cases\n\
    test_status=\$?\n\
    \n\
    # Cleanup\n\
    echo '=== Cleaning Up ==='\n\
    kill -9 \$appium_pid \$emulator_pid 2>/dev/null || true\n\
    adb emu kill\n\
    \n\
    exit \$test_status"]