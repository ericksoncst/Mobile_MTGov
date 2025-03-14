*** Settings ***
Resource  ../common/main.robot


*** Keywords ***
seleciono o icone do usuario
    VAR    ${icone_usuario}    //android.widget.TextView[@text="${letra}"]   
    Wait Until Element Is Visible    ${icone_usuario}
    Click Element    ${icone_usuario}