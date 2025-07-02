FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências básicas e Node.js (Appium)
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    curl \
    wget \
    unzip \
    python3-pip \
    python3-venv \
    adb \
    libgtk-3-0 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js 16 (recomendado para Appium)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Instalar Appium e Robot Framework libs
RUN npm install -g appium
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copiar APK para dentro do container
COPY apps/app.apk /apps/app.apk

# Expor porta padrão do Appium
EXPOSE 4723

# Start Appium + Xvfb (emulador rodando via X virtual framebuffer)
CMD Xvfb :99 -screen 0 1280x720x16 & \
    export DISPLAY=:99 && \
    appium
