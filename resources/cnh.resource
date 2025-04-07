*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${CNH}  //android.view.ViewGroup[@content-desc="CNH"]
${SEGUNDA-VIA}  //android.widget.Button[contains(@text,"SEGUNDA VIA")]
${BTN_INICIO}   //android.widget.TextView[@resource-id="br.gov.mt.cepromat.mtcidadao:id/bottom_navigation_item_title" and @text="Início"]



*** Keywords ***
o usuario esteja logado no APP DETRAN
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir


o usuario clicar na opção CNH
    Wait Until Element Is Visible    ${CNH}
    Click Element    ${CNH}


clicar na opção Segunda Via
    Wait Until Element Is Visible    ${SEGUNDA-VIA}  timeout=10s
    Click Element    ${SEGUNDA-VIA}
    Capture Page Screenshot  segunda_via.png
