FROM ubuntu:22.04

# Install minimal dependencies
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    python3-venv \
    wget \
    unzip \
    adb \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Use pre-built Android emulator image
COPY --from=androidsdk/android-30:latest /opt/android-sdk /opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# Install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    pip install robotframework robotframework-appiumlibrary

# Use standalone Appium server (no npm installation)
RUN wget https://github.com/appium/appium/releases/download/v2.0.0-beta.46/Appium-Server-GUI-linux-2.0.0-beta.46.AppImage && \
    chmod +x Appium-Server-GUI-linux-2.0.0-beta.46.AppImage

# Set up working directory
WORKDIR /app
COPY . .

# Entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]