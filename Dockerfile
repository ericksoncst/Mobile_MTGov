FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    python3-venv \
    wget \
    unzip \
    adb \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    virtinst \
    libgbm-dev \
    libnss3 \
    libasound2 \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Java 17 (required for Android SDK)
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java && \
    rm -rf /var/lib/apt/lists/*

# Set up Android SDK
ENV ANDROID_HOME=/opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip && \
    unzip -q commandlinetools-linux-10406996_latest.zip && \
    mv cmdline-tools latest && \
    rm commandlinetools-linux-10406996_latest.zip

ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# Accept licenses and install packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "emulator" "platforms;android-30" "system-images;android-30;google_apis;x86_64"

# Create AVD
RUN echo "no" | avdmanager create avd \
    --name test \
    --package "system-images;android-30;google_apis;x86_64" \
    --device "pixel_4" \
    --force

# Install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    pip install robotframework robotframework-appiumlibrary Appium-Python-Client==3.1.0

# Install Appium
RUN npm install -g appium && \
    appium driver install uiautomator2

# Set up working directory
WORKDIR /app
COPY . .

# Entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]