#!/bin/bash
set -e

# Configuration
APPIUM_HOST="localhost"
APPIUM_PORT="4723"
MAX_RETRIES=5
RETRY_DELAY=5

echo "📁 Creating results directory..."
mkdir -p results

echo "🔍 Verifying test files..."
if [ ! -d "test_cases" ]; then
  echo "❌ Error: test_cases directory not found!"
  ls -R /
  exit 1
fi

echo "🚀 Starting Appium server..."
appium --log-level error --relaxed-security --base-path /wd/hub &
APPIUM_PID=$!

# Function to check Appium readiness
check_appium() {
  curl -sSLf "http://${APPIUM_HOST}:${APPIUM_PORT}/wd/hub/status" > /dev/null
}

echo "⏳ Waiting for Appium to be ready..."
retries=0
until check_appium || [ $retries -eq $MAX_RETRIES ]; do
  retries=$((retries+1))
  echo "⚠️ Appium not ready, retry $retries/$MAX_RETRIES..."
  sleep $RETRY_DELAY
done

if [ $retries -eq $MAX_RETRIES ]; then
  echo "❌ Error: Appium failed to start after $MAX_RETRIES attempts"
  kill $APPIUM_PID
  exit 1
fi

echo "✅ Appium server is ready at http://${APPIUM_HOST}:${APPIUM_PORT}"

echo "🧪 Executing Robot Framework tests..."
robot --outputdir results test_cases || TEST_EXIT_CODE=$?

echo "🛑 Stopping Appium server..."
kill $APPIUM_PID

exit ${TEST_EXIT_CODE:-0}