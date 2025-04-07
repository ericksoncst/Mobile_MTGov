*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta CND
    [Tags]  CND
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP CND
    Quando o usuario clicar na opção CND
    E clicar na opção emitir cetidao de debito
    Então o app exibirá o campo tipo de certidão
    