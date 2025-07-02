FROM python:3.10-slim

# Instala dependências básicas
RUN apt-get update && apt-get install -y \
    curl nodejs npm android-tools-adb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Appium
RUN npm install -g appium

# Copia e instala requirements (já inclui robotframework)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Diretório de trabalho
WORKDIR /tests

# Copia seus testes
COPY ./test_cases /tests

# Copia entrypoint e dá permissão
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define o entrypoint
ENTRYPOINT ["/entrypoint.sh"]
