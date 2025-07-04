FROM ubuntu:22.04

# --- SYSTEM SETUP ---
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl unzip wget git python3 python3-pip \
    openjdk-11-jdk libgl1-mesa-dev libpulse-dev \
    libqt5widgets5 libqt5gui5 libqt5core5a \
    libqt5network5 qemu-kvm \
    && rm -rf /var/lib/apt/lists/*

# --- ANDROID SDK SETUP ---
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip && \
    unzip sdk.zip -d cmdline-tools && \
    mv cmdline-tools cmdline-tools/latest && \
    rm sdk.zip

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "emulator" "platforms;android-33" "system-images;android-33;google_apis;x86_64"

# --- CREATE AVD ---
RUN echo "no" | avdmanager create avd -n testEmulator -k "system-images;android-33;google_apis;x86_64" --device "pixel"

# --- PYTHON + ROBOT ---
RUN pip3 install robotframework robotframework-appiumlibrary

# --- INSTALL APPIUM ---
RUN npm install -g appium

# --- SETUP PROJECT STRUCTURE ---
WORKDIR /app
COPY . .

# --- VENV + DEPENDENCIES ---
RUN python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt || true

# --- STARTUP SCRIPT ---
CMD ["/bin/bash", "-c", "\
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator -no-audio -no-window -no-snapshot -no-boot-anim -ports 5554,5555 & \
    emulator_pid=$! && \
    echo '⏳ Waiting for emulator...' && \
    adb wait-for-device && \
    while [ \"$(adb shell getprop sys.boot_completed | tr -d '\r')\" != \"1\" ]; do \
        echo '🕐 Boot not complete yet...'; \
        sleep 5; \
    done && \
    echo '✅ Boot complete. Unlocking screen...' && \
    adb shell input keyevent 82 && \
    adb shell wm dismiss-keyguard && \
    sleep 10 && \
    echo '🚀 Starting Appium...' && \
    appium --relaxed-security --allow-insecure=adb_shell --base-path /wd/hub --address 0.0.0.0 --port 4723 --log-level debug &> /app/appium.log & \
    appium_pid=$! && \
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
    echo '🧪 Starting Robot tests...' && \
    source ./venv/bin/activate && \
    mkdir -p /app/test_results && \
    robot --outputdir /app/test_results /app/test_cases || true && \
    echo '✅ Tests completed.' && \
    kill -9 $appium_pid $emulator_pid 2>/dev/null || true && \
    tail -f /dev/null"]
