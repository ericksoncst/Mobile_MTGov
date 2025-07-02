#!/bin/bash

echo "🚀 Iniciando Appium..."
appium --log-level error &

echo "⏳ Aguardando Appium subir..."
sleep 10

echo "🎯 Executando testes Robot Framework..."
robot --outputdir /tests/results /tests
