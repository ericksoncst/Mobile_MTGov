#!/bin/bash

echo "🚀 Iniciando Appium..."
appium --log-level error &

# Aguarda o Appium responder na porta 4723
echo "⏳ Aguardando Appium estar pronto..."
until curl -s http://localhost:4723/wd/hub/status | grep -q '"ready":true'; do
  sleep 1
done

echo "✅ Appium está pronto!"

echo "🎯 Executando testes Robot Framework..."
robot --outputdir /tests/results /tests
