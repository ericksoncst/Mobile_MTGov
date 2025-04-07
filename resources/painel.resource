*** Settings ***
Resource  ../common/main.resource


*** Keywords ***
seleciono o icone do usuario
    VAR    ${icone_usuario}    //android.widget.TextView[@text="${letra}"]   
    Wait Until Element Is Visible    ${icone_usuario}
    Click Element    ${icone_usuario}

clicar no botao inicio
    Wait Until Element Is Visible   ${BTN_INICIO}
    Click Element   ${BTN_INICIO}
    