*** Settings ***
Resource  ../common/main.robot

*** Variables ***
${VEICULO}  //android.view.ViewGroup[@content-desc="Veículo"]/android.view.ViewGroup/android.view.ViewGroup
${BTN_INICIO}   //android.widget.TextView[@resource-id="br.gov.mt.cepromat.mtcidadao:id/bottom_navigation_item_title" and @text="Início"]




*** Keywords ***
o usuario esteja logado no APP VEICULO
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    clicar no botao entrar
    

o usuario clicar na opção VEÍCULO
    Wait Until Element Is Visible    ${VEICULO} 
    Click Element    ${VEICULO} 

#clicar no botao inicio
    Wait Until Element Is Visible   ${BTN_INICIO}
    Click Element    ${BTN_INICIO}