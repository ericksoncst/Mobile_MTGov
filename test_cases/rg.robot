*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app



*** Test Cases ***

Cenario 1 : Consulta RG 
    [Tags]  RG
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP
    Quando o usuario clicar na opção RG
    E clicar na opção Verificar cedula de identidade
    Então o app exibirá a frase Dicas para leitura de código
   