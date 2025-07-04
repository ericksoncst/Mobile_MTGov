*** Settings ***
Library  AppiumLibrary
Resource  ../common/main.resource

** Variables ***
${PLATFORM_NAME}    Android
${DEVICE_NAME}      emulator-5554
${APP_PATH}    ${EXECDIR}/apps/app.apk
${APP_PACKAGE}      br.gov.mt.cepromat.mtcidadao
${APP_ACTIVITY}     br.gov.mt.cepromat.mtcidadao.MainActivity
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
    ...    automationName=UiAutomator2
    ...    newCommandTimeout=300
    ...    adbExecTimeout=120000
    ...    ignoreHiddenApiPolicyError=true
    ...    uiautomator2ServerInstallTimeout=60000
    ...    autoGrantPermissions=true
    ...    isHeadless=true
    ...    enforceAppInstall=true
    ...    disableWindowAnimation=true
    ...    skipDeviceInitialization=false
    ...    skipServerInstallation=false

    Set Appium Timeout    5s

fechar app
    clicar no botao inicio
    seleciono o icone do usuario
    Wait Until Element Is Visible    //android.widget.TextView[@text="SAIR"]
    Click Element    //android.widget.TextView[@text="SAIR"]
    Wait Until Element Is Visible    //android.widget.Button[@resource-id="android:id/button1"]
    Click Element    //android.widget.Button[@resource-id="android:id/button1"]
    o usuario esteja na Home do APP
    Close All Applications


Setup Com Login
    [Arguments]    ${usuario_login}
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    abrir app
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    inserir o cpf ${usuario_login.CPF}
    inserir a senha ${usuario_login.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir