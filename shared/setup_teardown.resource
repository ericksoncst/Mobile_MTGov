*** Settings ***
Library  AppiumLibrary

*** Variables ***
${REMOTE_URL}       http://localhost:4723/wd/hub
${PLATFORM_NAME}    Android
${DEVICE_NAME}      emulator-5554
${PLATFORM_VERSION}  11.0
${APP_PATH}         /app/apps/app.apk
${APP_PACKAGE}      br.gov.mt.cepromat.mtcidadao
${APP_ACTIVITY}     br.gov.mt.cepromat.mtcidadao.MainActivity

*** Keywords ***
abrir app
    ${options}=    Create Dictionary
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    automationName=UiAutomator2
    ...    autoGrantPermissions=true
    
    Open Application    ${REMOTE_URL}    &{options}
    Set Appium Timeout    10s

fechar app
    Run Keyword And Ignore Error    Close Application
    Run Keyword And Ignore Error    Close All Applications