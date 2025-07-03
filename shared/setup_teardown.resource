*** Settings ***
Library    AppiumLibrary
Resource   ../common/main.resource

*** Variables ***
${REMOTE_URL}        http://localhost:4723/wd/hub
${PLATFORM_NAME}     Android
${DEVICE_NAME}       emulator-5554
${APP}               apps/app.apk
${APP_PACKAGE}       br.gov.mt.cepromat.mtcidadao
${APP_ACTIVITY}      br.gov.mt.cepromat.mtcidadao.MainActivity

*** Keywords ***
abrir app
    ${options}=    Create Dictionary
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    automationName=UiAutomator2
    ...    autoGrantPermissions=true

    Open Application    ${REMOTE_URL}    &{options}
    Set Appium Timeout  10s

Setup Com Login
    [Arguments]    ${usuario_login}
    abrir app
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    inserir o cpf ${usuario_login.CPF}
    inserir a senha ${usuario_login.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir

fechar app
    Run Keyword And Ignore Error    Close Application
