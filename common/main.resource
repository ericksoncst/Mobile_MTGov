*** Settings ***
Library  AppiumLibrary




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



*** Variables ***
${REMOTE_URL}    http://127.0.0.1:4723/wd/hub
${PLATFORM_NAME}    Android
${DEVICE_NAME}    emulator-5554
${PROJECT_ROOT}    ${CURDIR}/..
${APP}             ${PROJECT_ROOT}/apps/app.apk