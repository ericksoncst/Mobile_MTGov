*** Settings ***
Library    AppiumLibrary

*** Variables ***
${BROWSERSTACK_USERNAME}   ${BROWSERSTACK_USERNAME}
${BROWSERSTACK_ACCESS_KEY} ${BROWSERSTACK_ACCESS_KEY}
${APPIUM_SERVER}           https://${BROWSERSTACK_USERNAME}:${BROWSERSTACK_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub
${APP_ID}                  ${APP_ID}
${CAPABILITIES}            platformName=Android
...                        device=Google Pixel 3
...                        app=${APP_ID}
...                        automationName=UiAutomator2
...                        browserstack.debug=true

*** Keywords ***
Abrir app
    Log    Abrindo app no BrowserStack Appium
    Open Application    ${APPIUM_SERVER}    ${CAPABILITIES}
    Log    App aberto com sucesso

fechar app
    Log    Fechando app
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