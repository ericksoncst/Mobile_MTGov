FROM ubuntu:22.04

# 1. Install essential dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-pip \
    wget \
    unzip \
    openjdk-17-jdk \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    virtinst \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Android Command Line Tools
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip && \
    unzip -q commandlinetools-linux-10406996_latest.zip && \
    mv cmdline-tools latest && \
    rm commandlinetools-linux-10406996_latest.zip

# 3. Set environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

# 4. Install Android packages
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "emulator" \
    "platforms;android-30" \
    "system-images;android-30;google_apis;x86_64"

# 5. Create Android Virtual Device
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager create avd \
    --name test \
    --package "system-images;android-30;google_apis;x86_64" \
    --device "pixel_4" \
    --force

# 6. Install Python and Appium
RUN python3 -m pip install --upgrade pip && \
    pip install robotframework robotframework-appiumlibrary && \
    npm install -g appium && \
    appium driver install uiautomator2

WORKDIR /app
COPY . .

# 7. Health check and entrypoint
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 \
    CMD adb devices | grep emulator || exit 1

CMD ["sh", "-c", "emulator -avd test -no-audio -no-window -gpu swiftshader_indirect & \
     adb wait-for-device && \
     appium --relaxed-security --base-path /wd/hub & \
     while ! adb shell getprop sys.boot_completed | grep -q 1; do sleep 5; done && \
     robot --variable REMOTE_URL:http://localhost:4723/wd/hub \
           --variable PLATFORM_NAME:Android \
           --variable DEVICE_NAME:emulator-5554 \
           --variable APP:/app/apps/app.apk \
           --variable APP_PACKAGE:br.gov.mt.cepromat.mtcidadao \
           --variable APP_ACTIVITY:br.gov.mt.cepromat.mtcidadao.MainActivity \
           --outputdir results test_cases/"]