*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta SEGURANÇA PÚBLICA
    [Tags]  SEGURANÇA
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP SEGURANÇA PUBLICA
    Quando o usuario clicar na opção SEGURANÇA PUBLICA
    Então o app exibirá as opçoes de servicos para os usuarios
    