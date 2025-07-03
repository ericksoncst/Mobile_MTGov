FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Instalando dependências
RUN apt-get update && \
    apt-get install -y nodejs npm python3-pip python3-venv android-tools-adb openjdk-17-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurando Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d tmp && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    mv tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest/ && \
    rm -rf tools.zip tmp

# Testa sdkmanager (opcional)
RUN ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --version

# Instalando SDKs necessários (imagem ARM para evitar KVM)
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-30" \
        "system-images;android-30;google_apis;armeabi-v7a" \
        "emulator"

# Criar AVD com imagem ARM (pixel)
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager create avd -n testEmulator -k "system-images;android-30;google_apis;armeabi-v7a" --device "pixel" --force

# Instalar Appium globalmente
RUN npm install -g appium

# Diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY . .

# Criar ambiente Python e instalar dependências
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Comando de execução
CMD bash -c "\
    ${ANDROID_HOME}/emulator/emulator -avd testEmulator -no-audio -no-window & \
    emulator_pid=\$! && \
    sleep 60 && \
    appium & \
    appium_pid=\$! && \
    sleep 10 && \
    source ./venv/bin/activate && \
    robot --outputdir test_results test_cases && \
    kill \$appium_pid \$emulator_pid"
