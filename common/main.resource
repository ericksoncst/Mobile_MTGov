*** Settings ***
Library  AppiumLibrary




Resource  ../shared/gherkin.resource
Resource  ../shared/setup_teardown.resource
Resource  ../resources/login.resource
Resource  ../Data/credenciais.resource
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
${PLATFORM_NAME}    Android
${BROWSERSTACK_USERNAME}  nereucostanoguei1
${BROWSERSTACK_ACCESS_KEY}  qyNiqcXezmuw8A53MkM1