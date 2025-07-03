#!/bin/bash

# Start emulator
emulator -avd test -no-audio -no-window -gpu swiftshader_indirect &
adb wait-for-device

# Wait for boot completion
while [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
  sleep 5
done

# Start Appium
./Appium-Server-GUI-linux-2.0.0-beta.46.AppImage --relaxed-security &

# Run tests
robot --outputdir results test_cases/