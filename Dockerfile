FROM ubuntu:22.04

# 1. Atualizar e instalar dependências
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-17-jdk \
      wget \
      unzip \
      git \
      curl \
      python3 \
      python3-pip \
      python3-venv \
      nodejs \
      npm \
      android-tools-adb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Variáveis de ambiente do Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# 3. Baixar e instalar o Command Line Tools do Android
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d tools && \
    rm tools.zip

# 4. Instalar os pacotes SDK (imagem ARM para evitar erro do KVM)
RUN yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --licenses && \
    $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-30" \
        "system-images;android-30;google_apis;armeabi-v7a" \
        "emulator"

# 5. Instalar Appium e CLI para iniciar emulador
RUN npm install -g appium start-android-emulator

# 6. Instalar dependências Python
WORKDIR /app
COPY ./requirements.txt .
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# 7. Copiar arquivos da aplicação
COPY . .

# 8. Criar AVD
RUN echo "no" | avdmanager create avd -n testEmulator -k "system-images;android-30;google_apis;armeabi-v7a" --device "pixel" --force

# 9. Expor porta do Appium se necessário
EXPOSE 4723

# 10. Comando de entrada: start emulador, Appium e testes
CMD bash -c "\
    start-android-emulator testEmulator --headless & \
    emulator_pid=\$! && \
    echo '⌛ Aguardando emulador subir...' && \
    sleep 60 && \
    appium --log /tmp/appium.log & \
    appium_pid=\$! && \
    echo '✅ Appium iniciado. Executando testes...' && \
    sleep 10 && \
    source venv/bin/activate && \
    robot --outputdir test_results test_cases && \
    kill \$appium_pid \$emulator_pid"
