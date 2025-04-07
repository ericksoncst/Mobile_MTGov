*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app



*** Test Cases ***

Cenario 1 : Consulta CNH 
    [Tags]  CNH
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP DETRAN
    Quando o usuario clicar na opção CNH
    E clicar na opção Segunda Via
    