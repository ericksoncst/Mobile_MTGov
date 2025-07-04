*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta CELIACO
    [Tags]  celiaco
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP CELIACO
    Quando o usuario clicar na opção CELIACO
    E clicar na opção solicitar carteira celiaco
    Então o app exibirá a frase Carteira do Celíaco
    