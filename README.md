# Mobile App Testing with Robot Framework

This project contains automated tests for Android mobile applications using Robot Framework and Appium.

## Prerequisites

- Python 3.11 or higher
- Android SDK/ADB
- Appium Server
- Android Emulator or real device
- Git LFS (for handling large APK files)

## Setup

1. Clone the repository
```bash
git clone https://gitlab.mti.mt.gov.br/transformacao-digital/app-tester.git
cd app-tester
```

2. Create and activate virtual environment
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate.bat  # Windows
```

3. Install dependencies
```bash
pip install -r requirements.txt
```

4. Start Appium server
```bash
appium
```

## Running Tests

### Run all tests
```bash
robot test_cases/
```

### Run a specific test file
```bash
robot test_cases/login_mobile.robot
```

### Run a specific test case
```bash
robot -t "Nome do Teste" test_cases/login_mobile.robot
```

### Run tests with tags
```bash
robot -i usuario test_cases/login_mobile.robot
```

### Generate reports in a specific directory
```bash
robot --outputdir results test_cases/
```

## Project Structure

- `apps/` - Contains the application APK files
- `common/` - Shared resources and variables
- `data/` - Test data and credentials
- `resources/` - Robot Framework resource files organized by feature
- `shared/` - Common setup, teardown, and utilities
- `test_cases/` - Robot Framework test suite files

## Working with Large Files

This project uses Git LFS to handle large APK files. Make sure to install Git LFS before cloning:

```bash
# Install Git LFS
git lfs install

# When pushing changes that include large files
git lfs push --all origin YOUR_BRANCH
```

## Troubleshooting

If you encounter issues with the test execution:

1. Check that Appium server is running
2. Verify your device/emulator is connected: `adb devices`
3. Check the app permissions on the device
4. Review credentials in the data files