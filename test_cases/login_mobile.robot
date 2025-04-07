*** Settings ***
Resource    ../common/main.resource
Test Setup    Abrir app
Test Teardown   fechar app



*** Test Cases ***

Cenario 1 : logar no APP mt.gov.br com dados usuario
    [Tags]  usuario
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja na Home do APP
    Quando o usuario clicar no botao entrarCom
    E inserir o cpf ${USUARIO.CPF}
    E inserir a senha ${USUARIO.PASSWORD}
    E clicar no botao entrar
    #Então o sistema exibira o perfil logado


# Cenario 2 : logar no APP mt.gov.br com dados de servidor
#     [Tags]  servidor
#     VAR  ${letra}    ${SERVIDOR.LETRA}    scope=TEST
#     Dado que o usuario esteja na Home do APP
#     Quando o usuario clicar no botao entrarCom
#     E inserir o cpf ${SERVIDOR.CPF}
#     E inserir a senha ${SERVIDOR.PASSWORD}
#     E clicar no botao entrar
#     #Então o sistema exibira o perfil do usuario logado
