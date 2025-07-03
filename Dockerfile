FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Instalando ferramentas básicas
RUN apt-get update && \
    apt-get install -y nodejs npm python3-pip python3-venv android-tools-adb openjdk-17-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

# Baixar e extrair o command line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d latest && \
    rm tools.zip

# Aceitar licenças e instalar SDKs com imagem ARM (sem KVM)
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses && \
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-30" \
        "system-images;android-30;google_apis;armeabi-v7a" \
        "emulator"

# Instalar Appium e ferramenta para iniciar emulador
RUN npm install -g appium start-android-emulator

# Criar ambiente Python e instalar dependências
WORKDIR /app
COPY ./requirements.txt .
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Copiar todos os arquivos da aplicação e testes
COPY . .

# Criar o AVD com imagem ARM
RUN echo "no" | avdmanager create avd -n testEmulator -k "system-images;android-30;google_apis;armeabi-v7a" --device "pixel" --force

# Expor porta do Appium (caso necessário)
EXPOSE 4723

# Comando para iniciar emulador, appium e testes
CMD bash -c "\
    start-android-emulator testEmulator --headless & \
    emulator_pid=\$! && \
    echo '🔄 Aguardando emulador...' && \
    sleep 60 && \
    appium --log /tmp/appium.log & \
    appium_pid=\$! && \
    echo '✅ Appium iniciado. Rodando testes...' && \
    sleep 10 && \
    source venv/bin/activate && \
    robot --outputdir test_results test_cases && \
    kill \$appium_pid \$emulator_pid"
