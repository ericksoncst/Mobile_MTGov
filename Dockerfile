FROM ubuntu:20.04

# Evita prompts interativos (como configuração de fuso horário)
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza pacotes e instala dependências básicas + tzdata
RUN apt-get update && \
    apt-get install -y tzdata python3-pip nodejs npm curl && \
    ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Instala Appium e Robot Framework
RUN npm install -g appium && \
    pip3 install robotframework robotframework-appiumlibrary Appium-Python-Client

# Define diretório de trabalho
WORKDIR /tests

# Copia o projeto para dentro do container
COPY . .

# Inicia Appium, espera 10s e executa os testes
CMD appium > appium.log 2>&1 & \
    echo "⏳ Aguardando Appium iniciar..." && \
    sleep 10 && \
    robot --outputdir results test_cases
