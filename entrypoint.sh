#!/bin/bash
set -e

echo "📁 Criando diretório de resultados..."
mkdir -p results

echo "🚀 Executando testes Robot Framework..."
robot --outputdir results test_cases
