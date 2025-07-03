FROM ubuntu:20.04

# Instalação de dependências
RUN apt-get update && \
    apt-get install -y python3-pip nodejs npm curl && \
    npm install -g appium && \
    pip3 install robotframework robotframework-appiumlibrary Appium-Python-Client

# Define diretório de trabalho
WORKDIR /tests

# Copia o projeto
COPY . .

# Inicia Appium e roda os testes após aguardar
CMD appium > appium.log 2>&1 & \
    echo "⏳ Aguardando Appium iniciar..." && \
    sleep 10 && \
    robot --outputdir results test_cases
