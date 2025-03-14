*** Settings ***
Resource  ../common/main.robot

** Variables ***
${PLATFORM_NAME}    Android
${DEVICE_NAME}      emulator-5554 
${APP_PATH}         C:/MTGOV_MOBILE/Apps/app.apk
${APP_PACKAGE}      br.gov.mt.cepromat.mtcidadao
${APP_ACTIVITY}     br.gov.mt.cepromat.mtcidadao.MainActivity

*** Keywords ***
abrir app
    Open Application    http://localhost:4723/wd/hub
    ...    deviceName=${DEVICE_NAME}
    ...    platformName=${PLATFORM_NAME}
    ...    app=${APP_PATH}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    uiautomator2ServerInstallTimeout=60000
    ...    adbExecTimeout=60000
    ...    autoGrantPermissions=true

    Sleep    2s


fechar app
    clicar no botao inicio
    seleciono o icone do usuario
    Wait Until Element Is Visible    //android.widget.TextView[@text="SAIR"]
    Click Element    //android.widget.TextView[@text="SAIR"]
    Wait Until Element Is Visible    //android.widget.Button[@resource-id="android:id/button1"]
    Click Element    //android.widget.Button[@resource-id="android:id/button1"]
    o usuario esteja na Home do APP
    Close All Applications

