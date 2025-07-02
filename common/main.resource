*** Settings ***
Library    AppiumLibrary

*** Variables ***
${APPIUM_SERVER}    http://localhost:4723/wd/hub
${DEVICE_NAME}      Android Emulator
${PLATFORM_NAME}    Android
${APP_PATH}         /apps/app.apk

*** Keywords ***
Abrir app
    Log    Abrindo o app no Appium
    Open Application    ${APPIUM_SERVER}
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    Log    App aberto com sucesso

fechar app
    Log    Fechando o app
    Close Application


Resource  ../shared/gherkin.resource
Resource  ../shared/setup_teardown.resource
Resource  ../resources/login.resource
Resource  ../data/credenciais.resource
Resource  ../resources/cnh.resource
Resource  ../resources/painel.resource
Resource  ../resources/veiculo.resource
Resource  ../resources/rg.resource
Resource  ../resources/cnd.resource
Resource  ../resources/procon.resource
Resource  ../resources/consultar_empresas.resource
Resource  ../resources/carteira_de_autista.resource
Resource  ../resources/educacao.resource
Resource  ../resources/celiaco.resource
Resource  ../resources/seguranca_publica.resource