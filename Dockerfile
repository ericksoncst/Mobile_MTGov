FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV ANDROID_HOME=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

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

# Install Android Command Line Tools
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
    appium driver install uiautomator2 && \
    appium driver install xcuitest

# Set working directory and copy files
WORKDIR /app
COPY . .

# Create Python virtual environment
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Add wait script
RUN echo '#!/bin/bash\n\
adb wait-for-device\n\
while [ "$(adb shell getprop sys.boot_completed | tr -d '"'"'\r'"'"')" != "1" ]; do\n\
  sleep 1\n\
done\n\
sleep 10' > /wait_for_emulator.sh && \
    chmod +x /wait_for_emulator.sh

# Execution command
CMD ["/bin/bash", "-c", "\
    echo 'Starting emulator...' && \
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator -no-audio -no-window -no-boot-anim -no-snapshot -accel off & \
    emulator_pid=$! && \
    /wait_for_emulator.sh && \
    echo 'Starting Appium...' && \
    appium --relaxed-security & \
    appium_pid=$! && \
    sleep 10 && \
    echo 'Running tests...' && \
    source ./venv/bin/activate && \
    robot --outputdir test_results /app/test_cases || true && \
    echo 'Tests completed' && \
    kill $appium_pid $emulator_pid"]