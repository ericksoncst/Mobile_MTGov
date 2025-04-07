*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${CARTERIA_DE_AUTISTA}  //android.widget.TextView[@text="Carteira de Autista"]
${SOLICITAR_CARTEIRA}  //android.view.View[@resource-id="root"]/android.view.View[2]/android.view.View[1]
${BTN_PROXIMO}   //android.widget.Button[@text="PRÓXIMO"]
${FORMULARIO_DADOS_PESSOAIS}    (//android.widget.TextView[@text="Dados pessoais"])[2]


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
    Click Element    //android.widget.TextView[@text="Veja mais"]


o usuario clicar na opção CARTEIRA DE AUTISTA
    Wait Until Element Is Visible    ${CARTERIA_DE_AUTISTA} 
    Click Element   ${CARTERIA_DE_AUTISTA}   
    

clicar na opção solicitar carteira de autista
    Sleep    5s
    Wait Until Element Is Visible    ${SOLICITAR_CARTEIRA}
    Click Element   ${SOLICITAR_CARTEIRA}   
    Capture Page Screenshot  segunda_via.png
    



# Clicar no botão proximo
#     FOR    ${INDEX}    IN RANGE    10
#         ${VISIBLE}    Run Keyword And Return Status    Element Should Be Visible  ${BTN_PROXIMO}
#         IF    ${VISIBLE} == True
#             Click Element    ${BTN_PROXIMO}
#             BREAK
#         ELSE
#             Swipe    500    1500    500    500
#             Sleep    1s
#         END
#     END
#     Wait Until Element Is Visible    ${BTN_PROXIMO}    timeout=5s
#     Click Element   ${BTN_PROXIMO}


   


o sistema exibirá o formulario Dados Pessoais
    Wait Until Element Is Visible    ${FORMULARIO_DADOS_PESSOAIS}    
