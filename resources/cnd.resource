*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${CND}  //android.widget.TextView[@text="CND"]
${EMITIR_CERTIDAO}  //android.widget.Button[@text="new_debit Emitir nova certidão de débito"]
${BTN_INICIO}   //android.widget.TextView[@resource-id="br.gov.mt.cepromat.mtcidadao:id/bottom_navigation_item_title" and @text="Início"]
${TIPO_CERTIDAO}    //android.widget.TextView[@text="Tipo de Certidão"]


*** Keywords ***
o usuario esteja logado no APP CND
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir
    Capture Page Screenshot  tela_erro.png



o usuario clicar na opção CND
    Sleep    5s
    Wait Until Element Is Visible    ${CND}
    Click Element   ${CND}
    Capture Page Screenshot  tela.png
    

clicar na opção emitir cetidao de debito
    Wait Until Element Is Visible    ${EMITIR_CERTIDAO}
    Sleep    10s
    Click Element   ${EMITIR_CERTIDAO}   
    Capture Page Screenshot  certidao_debito.png


o app exibirá o campo tipo de certidão
    Sleep    5s
    Wait Until Element Is Visible   ${TIPO_CERTIDAO} 
    
