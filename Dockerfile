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

# Install Appium
RUN npm install -g appium@2.13.0 && \
    npm install -g appium-doctor && \
    appium driver install uiautomator2

# Create wait script in root
RUN echo '#!/bin/bash\n\
echo "Waiting for ADB..."\n\
adb wait-for-device\n\
echo "Waiting for boot completion..."\n\
while [ "$(adb shell getprop sys.boot_completed | tr -d '"'"'\r'"'"')" != "1" ]; do\n\
  echo "Emulator not ready yet..."\n\
  sleep 5\n\
  adb shell input keyevent 82\n\
done\n\
echo "Emulator ready!"\n\
sleep 15' > /wait_for_emulator.sh && \
    chmod +x /wait_for_emulator.sh

# Set working directory and copy files
WORKDIR /app
COPY . .
COPY ./apps/app.apk /app/apps/app.apk


# Create Python environment
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Execution command
CMD ["/bin/bash", "-c", "\
    # Start emulator with explicit ports
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator -no-audio -no-window -no-boot-anim -no-snapshot -ports 5554,5555 & \
    emulator_pid=$! && \
    
    # Wait for emulator (with enhanced checks)
    /wait_for_emulator.sh && \
    
    # Start Appium with proper config
    echo 'Starting Appium with debug...' && \
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
    
    # Wait for Appium (with backoff retries)
    echo 'Waiting for Appium...' && \
    for i in {1..10}; do \
      if curl -s http://localhost:4723/wd/hub/status >/dev/null; then \
        echo 'Appium ready!' && \
        break; \
      fi; \
      echo "Attempt $i: Appium not ready yet..."; \
      sleep 5; \
      if [ $i -eq 10 ]; then \
        echo 'Appium failed to start!'; \
        echo 'Last 50 lines of Appium log:'; \
        tail -n 50 /app/appium.log; \
        exit 1; \
      fi; \
    done && \
    
    # Run tests
    echo 'Running tests...' && \
    source ./venv/bin/activate && \
    robot --outputdir test_results /app/test_cases || true && \
    
    # Cleanup
    echo 'Test completed with status $?' && \
    kill -9 $appium_pid $emulator_pid 2>/dev/null || true"]