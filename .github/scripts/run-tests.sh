#!/bin/bash

set -e

echo "Waiting for emulator to boot..."
adb wait-for-device

until adb shell getprop sys.boot_completed | grep -m 1 "1"; do
  echo "Still waiting for boot..."
  sleep 5
done

echo "Extra delay to allow system services to stabilize..."
sleep 15

# Aguarda launcher ser iniciado
until adb shell pidof com.android.launcher3 > /dev/null; do
  echo "Waiting for launcher..."
  sleep 5
done

echo "Unlocking device..."
adb shell input keyevent 82 || true

echo "Installing APK..."
adb install -r "$(pwd)/apps/app.apk"

echo "Running Robot Framework tests..."
robot -d reports \
  -v REMOTE_URL:http://localhost:4723/wd/hub \
  -v DEVICE_NAME:emulator-5554 \
  test_cases/
