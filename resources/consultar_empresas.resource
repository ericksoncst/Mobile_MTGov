*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${CONSULTAR_EMPRESA}  //android.view.ViewGroup[@content-desc="Consultar Empresas"]/android.view.ViewGroup
${CONSULTAR_POR_CPF}  //android.widget.TextView[@text="Consultar Empresas por CPF"]
${CAMPO-CPF}   //android.widget.TextView[@text="CPF"]



*** Keywords ***
o usuario esteja logado no APP CONSULTAR EMPRESAS
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir
    Click Element    //android.widget.TextView[@text="Veja mais"]

o usuario clicar na opção CONSULTAR EMPRESAS
    Wait Until Element Is Visible    ${CONSULTAR_EMPRESA}
    Click Element    ${CONSULTAR_EMPRESA} 

clicar na opção consultar empresa por CPF
    Sleep    10s
    Wait Until Element Is Visible    ${CONSULTAR_POR_CPF}  
    Click Element    ${CONSULTAR_POR_CPF} 
    Capture Page Screenshot  segunda_via.png

o app exibirá o campo CPF
    Wait Until Element Is Visible    ${CAMPO-CPF} 
    Click Element    ${CAMPO-CPF} 
