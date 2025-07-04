#!/bin/bash
set -e

# Start emulator
/wait_for_emulator.sh

# Install APK
echo "💿 Installing APK..."
adb install -t -g /app/apps/app.apk &> /app/install.log || \
  echo "⚠️ APK install failed (continuing)"

# Start Appium
echo "🌐 Starting Appium..."
appium \
  --relaxed-security \
  --allow-insecure=apk_check \
  --base-path /wd/hub \
  --address 0.0.0.0 \
  --port 4723 &> /app/appium.log &
appium_pid=$!

# Verify Appium is ready
echo "⏳ Waiting for Appium (max 2m)..."
timeout 120 bash -c '
  until nc -z localhost 4723 && \
    curl -s http://localhost:4723/wd/hub/status | grep -q "status\":0"; do
    sleep 5
  done
' || {
  echo "❌ Appium failed to start"
  echo "=== Appium Log ==="
  tail -n 50 /app/appium.log
  exit 1
}

# Run tests
echo "🔍 Running tests..."
source /app/venv/bin/activate
robot --outputdir /app/test_results /app/test_cases
test_exit=$?

# Keep container alive for debugging
tail -f /dev/null