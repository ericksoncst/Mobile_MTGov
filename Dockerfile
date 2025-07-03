FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Instalando ferramentas básicas com Java 17
RUN apt-get update && \
    apt-get install -y nodejs npm python3-pip python3-venv android-tools-adb openjdk-17-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

# Instalar SDK Command Line Tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip && \
    rm tools.zip && \
    mv cmdline-tools latest

# Aceitar licenças e instalar componentes do Android
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "system-images;android-30;google_apis;x86_64" "emulator"

# Instalar Appium e lib para subir emulador
RUN npm install -g appium start-android-emulator

# Criar ambiente Python e instalar dependências
WORKDIR /app
COPY ./requirements.txt .
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Copiar tudo que for necessário para testes
COPY . .

# Criar AVD e preparar emulador
RUN echo "no" | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd -n testEmulator -k "system-images;android-30;google_apis;x86_64" --device "pixel" --force

# Comando de inicialização
CMD start-android-emulator testEmulator --headless & \
    sleep 60 && \
    appium & \
    sleep 10 && \
    exec ./venv/bin/robot --outputdir tests/results tests
