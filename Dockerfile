# Dockerfile for Android Emulator and Robot Framework Testing
# ----------------------------------------------------------

FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Install required tools
RUN apt-get update && \
    apt-get install -y nodejs npm python3-pip android-tools-adb python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up environment
WORKDIR /app
COPY ./requirements.txt .

# Install dependencies
RUN npm install -g appium && \
    python3 -m venv venv && \
    . venv/bin/activate && \
    pip3 install -r requirements.txt && \
    pip3 install robotframework robotframework-appiumlibrary

# Copy test scripts and APK
COPY ./tests /app/tests
COPY ./apps/app.apk /app/apps/app.apk

# Expose Appium port
EXPOSE 4723

# Create entrypoint script
RUN echo '#!/bin/bash\n\
. /app/venv/bin/activate\n\
echo "🚀 Starting Appium Server"\n\
appium --log-level error &\n\
sleep 5\n\
echo "🎯 Running tests with Robot Framework"\n\
robot --outputdir /app/tests/results /app/tests\n\
' > /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]