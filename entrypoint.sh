#!/bin/bash

# Start emulator
emulator -avd test -no-audio -no-window -gpu swiftshader_indirect &
adb wait-for-device

# Wait for emulator to fully boot
while [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
  sleep 5
  echo "Waiting for emulator to boot..."
done

# Start Appium
appium --relaxed-security --base-path /wd/hub &

# Run tests
robot --outputdir results test_cases/

# Capture emulator logs if tests failed
if [ $? -ne 0 ]; then
  adb logcat -d > results/emulator.log
fi