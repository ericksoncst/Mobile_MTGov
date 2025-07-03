FROM ubuntu:22.04

# 1. Install only essential dependencies
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    wget \
    unzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Android Command Line Tools (minimal)
RUN mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    cd /opt/android-sdk/cmdline-tools/latest && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip && \
    unzip -q commandlinetools-linux-10406996_latest.zip && \
    rm commandlinetools-linux-10406996_latest.zip

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# 3. Accept licenses and install minimum required packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "emulator" "platforms;android-30"

# 4. Install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    pip install robotframework robotframework-appiumlibrary

# 5. Use standalone Appium (no npm needed)
RUN wget https://github.com/appium/appium-inspector/releases/download/v2023.6.1/Appium-Inspector-linux-2023.6.1.AppImage -O /usr/local/bin/appium && \
    chmod +x /usr/local/bin/appium

WORKDIR /app
COPY . .

# 6. Simple entrypoint
CMD ["sh", "-c", "appium & adb devices && robot --outputdir results test_cases/"]