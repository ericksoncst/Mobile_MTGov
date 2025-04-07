*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${PROCON}  //android.widget.TextView[@text="Procon"]
${FAZER-RECLAMACAO}   //android.widget.Button[@text="Fazer uma reclamação"]
${INICIAR_RECLAMACAO}    //android.widget.Button[@text="INICIAR RECLAMAÇÃO"]
${CAMPO_FORNECEDOR}   //android.widget.EditText[@resource-id="denounced-autocomplete"]
${BTN_INICIO}   //android.widget.TextView[@resource-id="br.gov.mt.cepromat.mtcidadao:id/bottom_navigation_item_title" and @text="Início"]


*** Keywords ***
o usuario esteja logado no APP PROCON
    o usuario esteja na Home do APP
    Sleep    5s
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir


o usuario clicar na opção PROCON
    Wait Until Element Is Visible    ${PROCON}
    Click Element   ${PROCON}  
    

clicar opçao fazer uma reclamacao
    Sleep    5s
    Wait Until Element Is Visible   ${FAZER-RECLAMACAO}  
    Click Element   ${FAZER-RECLAMACAO}  
    Capture Page Screenshot  segunda_via.png


clicar opcao iniciar reclamacao
    Wait Until Element Is Visible   ${INICIAR_RECLAMACAO} 
    Click Element    ${INICIAR_RECLAMACAO}  

o app exibirá o campo fornecedor
    Wait Until Element Is Visible   ${CAMPO_FORNECEDOR} 
