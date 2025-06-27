*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${CARTERIA_DE_AUTISTA}  //android.view.ViewGroup[@content-desc="Carteira de Autista"]/android.view.ViewGroup/android.view.ViewGroup/com.horcrux.svg.SvgView/com.horcrux.svg.GroupView/com.horcrux.svg.PathView[2]
${SOLICITAR_CARTEIRA}  //android.widget.TextView[@text="Solicitar carteira do autista"]
#//android.view.View[@resource-id="root"]/android.view.View[2]/android.view.View[1]
${BTN_PROXIMO}   //android.widget.Button[@resource-id="processo-continuar"]
${FORMULARIO_INFORMAÇÕES}  //android.widget.TextView[@text="Autista"]
#//android.view.View[@resource-id="xvia-main"]
${FORMULARIO_DADOS_PESSOAIS}    (//android.widget.TextView[@text="Dados pessoais"])[2]
${VERIFICAR_CARTEIRA_AUTISTA}  //android.widget.TextView[@text="Verificar carteira do autista"]
#//android.view.View[@resource-id="root"]/android.view.View[2]/android.view.View[2]
${BTN_VERIFICAR}  //android.widget.Button[@text="VERIFICAR"]
#//android.widget.Button[@text="VERIFICAR"]
${POSICIONE_QR_CODE}  //android.app.Dialog[@text="Posicione o QR code dentro do quadro"]/android.widget.Button

*** Keywords ***
o usuario esteja logado no APP CARTERIA DE AUTISTA
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir
   


o usuario clicar na opção CARTEIRA DE AUTISTA
    Click Element    //android.widget.TextView[@text="Veja mais"]
    Sleep    8s
    Wait Until Element Is Visible    ${CARTERIA_DE_AUTISTA} 
    Click Element   ${CARTERIA_DE_AUTISTA}   
    

clicar na opção solicitar carteira de autista
    Sleep    5s
    Wait Until Element Is Visible    ${SOLICITAR_CARTEIRA}
    Click Element   ${SOLICITAR_CARTEIRA}   
    Capture Page Screenshot  segunda_via.png


# clicar no botão proximo
#     Swipe    500    1500    500    500    5000
#     Sleep    5s
#     Wait Until Element Is Visible   ${BTN_PROXIMO}
#     Click Element   ${BTN_PROXIMO}  

o sistema exibira a tela informações
    Sleep    10s
    Wait Until Element Is Visible    ${FORMULARIO_INFORMAÇÕES}
    Click Element   ${FORMULARIO_INFORMAÇÕES}  
        
    
# clicar no botão proximo
#     Sleep    5s
#     Swipe    500    1900    500    100    1000
#     Wait Until Element Is Visible    ${BTN_PROXIMO}
#     Click Element   ${BTN_PROXIMO}   

# o sistema exibirá o formulario Dados Pessoais
#     Wait Until Element Is Visible    ${FORMULARIO_DADOS_PESSOAIS}    

#### VERIFICAR CARTERIA DE AUTISTA ###
clicar na opção verificar carteira de autista
    Sleep    5s
    Wait Until Element Is Visible    ${VERIFICAR_CARTEIRA_AUTISTA} 
    Click Element   ${VERIFICAR_CARTEIRA_AUTISTA} 

clicar no botao verificar 
    Sleep    5s
    Wait Until Element Is Visible    ${BTN_VERIFICAR}  
    Click Element   ${BTN_VERIFICAR}  

sera exibido o QR Code 
    Sleep    5s
    Wait Until Element Is Visible    ${POSICIONE_QR_CODE}
     



