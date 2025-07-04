*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta CARTERIA DE AUTISTA
    [Tags]  AUTISTA
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP CARTERIA DE AUTISTA
    Quando o usuario clicar na opção CARTEIRA DE AUTISTA
    E clicar na opção solicitar carteira de autista
    #E clicar no botão proximo
    #Então o sistema exibirá o formulario Dados Pessoais
    