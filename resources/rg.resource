*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${RG}  //android.widget.TextView[@text="RG"]
${VERIFICAR_CEDULA}  //android.widget.Button[@text="VERIFICAR CÉDULA DE IDENTIDADE"]
${BTN_INICIO}   //android.widget.TextView[@resource-id="br.gov.mt.cepromat.mtcidadao:id/bottom_navigation_item_title" and @text="Início"]
${CODIGO_QR}    //android.widget.TextView[@text="Dicas para leitura do código QR"]


*** Keywords ***
o usuario esteja logado no APP
    o usuario esteja na Home do APP
    Sleep    5s
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir

o usuario clicar na opção RG
    Wait Until Element Is Visible    ${RG} 
    Click Element    ${RG} 

clicar na opção Verificar cedula de identidade
    Wait Until Element Is Visible    ${VERIFICAR_CEDULA}  timeout=8s  
    Click Element    ${VERIFICAR_CEDULA}  
    Capture Page Screenshot  segunda_via.png

o app exibirá a frase Dicas para leitura de código
    Wait Until Element Is Visible    ${CODIGO_QR}
    Click Element    ${CODIGO_QR} 
