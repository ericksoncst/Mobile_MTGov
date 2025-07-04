*** Settings ***
Resource    ../common/main.resource
Test Setup    Setup Com Login  usuario_login=&{USUARIO}
Test Teardown   fechar app

Test Tags  carteira_autista

*** Test Cases ***

Cenario 1 : Consulta SOLICITAR CARTERIA DE AUTISTA
    [Tags]  solicitar_carteira
    Dado que vejo o painel do cidadão logado
    Quando o usuario clicar na opção CARTEIRA DE AUTISTA
    E clicar na opção solicitar carteira de autista
    Então o sistema exibira a tela informações
   

Cenario 2 : Consulta VERIFICAR CARTERIA DE AUTISTA
        [Tags]  verificar_carteira
        Dado que vejo o painel do cidadão logado
        Quando o usuario clicar na opção CARTEIRA DE AUTISTA
        E clicar na opção verificar carteira de autista
        E clicar no botao verificar
        Então sera exibido o QR Code