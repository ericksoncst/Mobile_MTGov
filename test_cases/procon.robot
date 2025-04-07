*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta PROCON
    [Tags]  CND
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP PROCON
    Quando o usuario clicar na opção PROCON
    E clicar opçao fazer uma reclamacao
    E clicar opcao iniciar reclamacao
    Então o app exibirá o campo fornecedor