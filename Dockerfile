FROM ubuntu:22.04

# Basic setup
ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk \
    PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Install minimal dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        openjdk-17-jdk \
        android-tools-adb \
        python3 \
        python3-pip \
        python3-venv && \
    apt-get clean

# Install Android tools
RUN mkdir -p $ANDROID_HOME && \
    cd $ANDROID_HOME && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip -q tools.zip -d cmdline-tools/latest && \
    rm tools.zip

# Accept licenses and install packages
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --sdk_root=$ANDROID_HOME \
    "platform-tools" \
    "platforms;android-30" \
    "emulator" && \
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --sdk_root=$ANDROID_HOME \
    "system-images;android-30;google_apis;x86_64"

# Create AVD
RUN echo "no" | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd \
    -n test -k "system-images;android-30;google_apis;x86_64" --force

# Copy test files
WORKDIR /app
COPY . .

# Install Python dependencies
RUN python3 -m venv venv && \
    ./venv/bin/pip install -r requirements.txt

# Simple run command
CMD ["/bin/bash", "-c", "\
    $ANDROID_HOME/emulator/emulator -avd test -no-audio -no-window -no-snapshot & \
    adb wait-for-device && \
    source ./venv/bin/activate && \
    robot --outputdir results test_cases"]