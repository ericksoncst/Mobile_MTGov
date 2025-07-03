FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Instalando dependências
RUN apt-get update && \
    apt-get install -y nodejs npm python3-pip python3-venv android-tools-adb openjdk-17-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configura variáveis de ambiente
ENV ANDROID_HOME=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"

# Instala Android Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d tmp && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    mv tmp/cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/ && \
    rm -rf tools.zip tmp

# Verifica sdkmanager
RUN ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root="${ANDROID_HOME}" --version

# Instala SDKs necessários (com imagem ARM, que roda sem aceleração de hardware)
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root="${ANDROID_HOME}" --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root="${ANDROID_HOME}" \
        "platform-tools" \
        "platforms;android-30" \
        "emulator" --channel=0 && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root="${ANDROID_HOME}" \
        "system-images;android-30;google_apis_playstore;armeabi-v7a" --channel=0

# Cria o AVD com imagem ARM
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager \
    create avd -n testEmulator -k "system-images;android-30;google_apis;armeabi-v7a" \
    --device "pixel_4" --force

# Instala Appium
RUN npm install -g appium

# Define diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto
COPY . .

# Cria ambiente virtual e instala dependências Python
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Comando de execução
CMD ["/bin/bash", "-c", "\
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator -no-audio -no-window -no-boot-anim -accel off & \
    emulator_pid=$! && \
    echo 'Aguardando emulador iniciar...' && \
    ${ANDROID_HOME}/platform-tools/adb wait-for-device && \
    sleep 20 && \
    appium & \
    appium_pid=$! && \
    sleep 10 && \
    source ./venv/bin/activate && \
    robot --outputdir test_results test_cases && \
    kill $appium_pid $emulator_pid"]
