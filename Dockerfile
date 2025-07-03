FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Instalando dependências
RUN apt-get update && \
    apt-get install -y nodejs npm python3-pip python3-venv android-tools-adb openjdk-17-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurando Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip && \
    mv cmdline-tools latest && \
    rm tools.zip

# Instalando SDKs necessários
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
      "platform-tools" \
      "platforms;android-30" \
      "system-images;android-30;google_apis;x86_64" \
      "emulator"

# Instalando Appium e dependências Node
RUN npm install -g appium

# Criar AVD
RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager create avd \
      -n testEmulator -k "system-images;android-30;google_apis;x86_64" \
      --device "pixel" --force

# Diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto
COPY . .

# Instalar dependências Python
RUN python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Comando de execução
CMD $ANDROID_HOME/emulator/emulator -avd testEmulator -no-audio -no-window & \
    sleep 60 && \
    appium & \
    sleep 10 && \
    ./venv/bin/robot --outputdir test_results test_cases
