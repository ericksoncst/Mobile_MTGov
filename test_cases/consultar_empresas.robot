*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta EMPRESAS
    [Tags]  CND
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP CONSULTAR EMPRESAS
    Quando o usuario clicar na opção CONSULTAR EMPRESAS
    E clicar na opção consultar empresa por CPF
    Então o app exibirá o campo CPF
    