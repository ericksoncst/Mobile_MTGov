*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${HOME_PAGE}        //android.widget.ImageView
${BOTAO_ENTRAR}    //android.widget.TextView[@text="ENTRAR COM"]
${FIELD_CPF}           //android.widget.EditText[@resource-id="username"]
${FIELD_PASSWORD}      //android.widget.EditText[@resource-id="password"]
${BTN_ENTRAR}    //android.widget.Button[@resource-id="kc-login"]
${PERMITIR}      com.android.packageinstaller:id/permission_allow_button
${PERFIL_CIDADAO}  //android.widget.TextView[@text="Perfil Cidadão"]


*** Keywords ***
o usuario esteja na Home do APP
    Wait Until Element Is Visible    ${BOTAO_ENTRAR}
    clicar no botão permitir


o usuario clicar no botao entrarCom
    Wait Until Element Is Visible    ${BOTAO_ENTRAR}
    Click Element  ${BOTAO_ENTRAR}
    clicar no botão permitir
    


clicar no botao entrar
    Wait Until Element Is Visible    ${BTN_ENTRAR}
    Click Element  ${BTN_ENTRAR}
    clicar no botão permitir


o sistema exibira o perfil logado
   clicar no botão permitir
    Wait Until Element Is Visible    ${PERFIL_CIDADAO}


clicar no botão permitir
    ${passou}  Run Keyword And Return Status
    ...    Wait Until Element Is Visible  ${PERMITIR}
    Run Keyword If   ${passou}  Click Element    ${PERMITIR}


inserir o cpf ${cpf}
    Wait Until Page Contains Element  ${FIELD_CPF}
    Click Element  ${FIELD_CPF}
    Input Text  ${FIELD_CPF}  ${cpf}


inserir a senha ${senha}
    Click Element  ${FIELD_PASSWORD}
    Input Text  ${FIELD_PASSWORD}  ${senha}
    Hide Keyboard
