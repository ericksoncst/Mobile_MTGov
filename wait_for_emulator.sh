#!/bin/bash
adb wait-for-device
while [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
  sleep 1
done
sleep 10  # Additional wait for services to start