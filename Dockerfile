# Dockerfile for Android Emulator and Robot Framework Testing
# ----------------------------------------------------------

    FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

    # Install required tools
    # Node.js and npm for Appium, Python for Robot Framework, ADB for Android device management
    RUN apt-get update && \
        apt-get install -y nodejs npm python3-pip android-tools-adb python3-venv && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* # Clean up apt cache to reduce image size
    
    # # Create a non-root user for running applications
    # RUN useradd -m appuser
    # USER appuser
    
    # Set up environment
    WORKDIR /
    COPY ./requirements.txt ./requirements.txt
    
    # Install Appium and Robot Framework dependencies
    RUN npm install -g appium && \
        python3 -m venv venv && \
        . venv/bin/activate && \
        pip3 install -r requirements.txt && \
        pip3 install robotframework robotframework-appiumlibrary
    
    # Copy test scripts and APK into the Docker image
    # COPY ./tests /home/appuser/tests
    COPY ./apps/app.apk /apps/app.apk
    
    # # Start Appium Server in the background
    # CMD echo "🚀 Iniciando Appium Server" && \
    #     appium --log-level error &
    
    # # Execute tests with Robot Framework
    # CMD echo "🎯 Executando testes com Robot Framework" && \
    #     robot --outputdir /tests/results /tests

    CMD appium > appium.log 2>&1 & \
    echo "⏳ Aguardando Appium iniciar..." && \
    sleep 10 && \
    robot --outputdir results test_cases
    
    # Define artifacts directory (handled by CI/CD system, not Docker)
    # artifacts:
    #   when: always
    #   paths:
    #     - /home/appuser/tests/results/
    #     - /home/appuser/tests/results/output.xml
    #     - /home/appuser/tests/results/report.html
    #     - /home/appuser/tests/results/log.html
    #   expire_in: 7 days