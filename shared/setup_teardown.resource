*** Settings ***
Library    AppiumLibrary
Resource   ../common/main.resource

*** Variables ***
${PLATFORM_NAME}      Android
${DEVICE_NAME}        emulator-5554
${APP_PATH}           /app/apps/app.apk
${APP_PACKAGE}        br.gov.mt.cepromat.mtcidadao
${APP_ACTIVITY}       br.gov.mt.cepromat.mtcidadao.MainActivity

*** Keywords ***
abrir app
    [Timeout]    5 minutes
    Wait Until Keyword Succeeds    5x    30s    Open Application
    ...    http://127.0.0.1:4723
    ...    automationName=UiAutomator2
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    newCommandTimeout=600
    ...    uiautomator2ServerInstallTimeout=120000
    ...    adbExecTimeout=120000

fechar app
    clicar no botao inicio
    seleciono o icone do usuario
    Wait Until Element Is Visible    //android.widget.TextView[@text="SAIR"]
    Click Element                    //android.widget.TextView[@text="SAIR"]
    Wait Until Element Is Visible    //android.widget.Button[@resource-id="android:id/button1"]
    Click Element                    //android.widget.Button[@resource-id="android:id/button1"]
    o usuario esteja na Home do APP
    Close All Applications

Setup Com Login
    [Arguments]    ${usuario_login}
    VAR    ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    abrir app
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    inserir o cpf ${usuario_login.CPF}
    inserir a senha ${usuario_login.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir
