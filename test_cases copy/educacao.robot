*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app


*** Test Cases ***

Cenario 1 : Consulta EDUCAÇÃO
    [Tags]  CND
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP EDUCACAO
    Quando o usuario clicar na opção EDUCACAO
    #E clicar na opçao meus alunos
    #Então o app exibirá o campo Selecione o ano letivo
    