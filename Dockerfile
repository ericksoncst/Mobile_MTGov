FROM python:3.10-slim

# Instalações básicas (Appium, Android tools, Node.js)
RUN apt-get update && apt-get install -y \
    curl nodejs npm android-tools-adb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Appium
RUN npm install -g appium

# Instala dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia testes e app
WORKDIR /tests
COPY ./test_cases /tests
COPY ./apps/app.apk /apps/app.apk

# Entrypoint para rodar Appium + testes
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
