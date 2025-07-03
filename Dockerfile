FROM ubuntu:22.04

# 1. Install essential dependencies with clean apt
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-pip \
    wget \
    unzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Android Command Line Tools PROPERLY
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip && \
    unzip -q commandlinetools-linux-10406996_latest.zip && \
    mv cmdline-tools latest && \
    rm commandlinetools-linux-10406996_latest.zip

# 3. Set PATH correctly (critical fix)
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# 4. Accept licenses and install packages (with proper PATH)
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "emulator" "platforms;android-30"

# 5. Install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    pip install robotframework robotframework-appiumlibrary

# 6. Use pre-built Appium server (no npm needed)
RUN wget https://github.com/appium/appium-inspector/releases/download/v2023.12.1/Appium-Inspector-linux-2023.12.1.AppImage -O /usr/local/bin/appium && \
    chmod +x /usr/local/bin/appium

WORKDIR /app
COPY . .

# 7. Simple entrypoint
CMD ["sh", "-c", "appium & adb devices && robot --outputdir results test_cases/"]