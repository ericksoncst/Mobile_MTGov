*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${CELIACO}  //android.widget.TextView[@text="Celíaco"]
${SOLICITAR_CARTERIA_CELIACO}  //android.widget.Button[@text="Solicitar carteira de celíaco Solicita e emite Carteira de Celíaco digital"]
${CARTEIRA_CELIACO}   //android.widget.TextView[@text="Carteira de Celíaco"]



*** Keywords ***
o usuario esteja logado no APP CELIACO
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir
    Click Element    //android.widget.TextView[@text="Veja mais"]
    Capture Page Screenshot  tela_erro.png



o usuario clicar na opção CELIACO
    Wait Until Element Is Visible    ${CELIACO} 
    Click Element   ${CELIACO} 
    Capture Page Screenshot  tela.png
    

clicar na opção solicitar carteira celiaco
    Wait Until Element Is Visible    ${SOLICITAR_CARTERIA_CELIACO} 
    Click Element   ${SOLICITAR_CARTERIA_CELIACO}   
    Capture Page Screenshot  certidao_debito.png


o app exibirá a frase Carteira do Celíaco
    Sleep    10s
    Wait Until Element Is Visible   ${CARTEIRA_CELIACO} 
    
