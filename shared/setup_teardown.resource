*** Settings ***
Library  AppiumLibrary
Resource  ../common/main.resource

*** Variables ***
${REMOTE_URL}       http://${BROWSERSTACK_USERNAME}:${BROWSERSTACK_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub
${PLATFORM_NAME}    Android
${DEVICE_NAME}      Google Pixel 6
${PLATFORM_VERSION}  12.0
${APP_PACKAGE}      br.gov.mt.cepromat.mtcidadao
${APP_ACTIVITY}     br.gov.mt.cepromat.mtcidadao.MainActivity

*** Keywords ***
abrir app
    ${BROWSERSTACK_OPTIONS}=    Create Dictionary
    ...    userName=${BROWSERSTACK_USERNAME}
    ...    accessKey=${BROWSERSTACK_ACCESS_KEY}
    ...    projectName=MTGov Mobile Tests
    ...    buildName=Build ${BUILD_NUMBER}
    ...    sessionName=${SUITE_NAME}
    ...    debug=true
    ...    networkLogs=true

    ${options}=    Create Dictionary
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    automationName=UiAutomator2
    ...    autoGrantPermissions=true
    ...    bstack:options=${BROWSERSTACK_OPTIONS}
    
    Open Application    ${REMOTE_URL}    &{options}
    Set Appium Timeout    10s

fechar app
    Run Keyword And Ignore Error    Close Application
    Run Keyword And Ignore Error    Close All Applications

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