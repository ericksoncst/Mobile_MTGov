#!/bin/bash
set -e

echo "📁 Criando diretório de resultados..."
mkdir -p results

echo "📂 Listando arquivos:"
ls -R /tests

echo "🚀 Executando testes Robot Framework..."
robot --outputdir results test_cases

