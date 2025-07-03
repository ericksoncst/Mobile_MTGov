FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Fuso horário e dependências básicas
RUN apt-get update && \
    apt-get install -y tzdata python3-pip curl gnupg && \
    ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Instala Node.js 18.x (compatível com Appium 2.x)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Instala Appium e bibliotecas Python
RUN npm install -g appium && \
    pip3 install robotframework robotframework-appiumlibrary Appium-Python-Client

# Define diretório do projeto
WORKDIR /tests

# Copia os arquivos do projeto
COPY . .

# Comando final: inicia Appium, aguarda, e roda testes Robot
CMD appium > appium.log 2>&1 & \
    echo "⏳ Aguardando Appium iniciar..." && \
    sleep 10 && \
    robot --outputdir results test_cases
