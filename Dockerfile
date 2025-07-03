FROM registry-gitlab.mti.mt.gov.br/docker-images/ubuntu

# Instala dependências básicas
RUN apt-get update && \
    apt-get install -y \
        nodejs \
        npm \
        python3 \
        python3-pip \
        android-tools-adb \
        curl \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia os arquivos necessários
COPY requirements.txt requirements.txt
COPY ./apps/app.apk /app/apps/app.apk
COPY ./test_cases /app/test_cases  # ajuste conforme a estrutura real

# Instala Appium e dependências Python (Robot Framework, AppiumLibrary, etc)
RUN npm install -g appium && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    pip3 install robotframework robotframework-appiumlibrary

# Porta exposta para Appium
EXPOSE 4723

# Comando para iniciar Appium e rodar os testes
CMD appium > appium.log 2>&1 & \
    echo "⏳ Aguardando Appium iniciar..." && \
    sleep 10 && \
    robot --outputdir results test_cases
