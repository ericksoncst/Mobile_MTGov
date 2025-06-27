*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${VEICULO}  //android.view.ViewGroup[@content-desc="Veículo"]/android.view.ViewGroup/android.view.ViewGroup/com.horcrux.svg.SvgView/com.horcrux.svg.GroupView/com.horcrux.svg.PathView
#//android.view.ViewGroup[@content-desc="Veículo"]/android.view.ViewGroup/android.view.ViewGroup/com.horcrux.svg.SvgView/com.horcrux.svg.GroupView/com.horcrux.svg.PathView
${MARCA_VEICULO}  //android.view.View[@resource-id="root"]/android.view.View/android.view.View[2]/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View[1]
#//android.view.View[@resource-id="root"]/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.view.View[2]/android.view.View/android.view.View[1]
${LICENCIAMENTO_ANUAL}  //android.widget.ListView/android.view.View[1]/android.view.View/android.view.View/android.view.View[1]
#${LICENCIAMENTO_ANO_ANTERIOR}  //android.widget.ListView/android.view.View[2]/android.view.View/android.view.View
${VERIFICAR_DEBITO}  //android.view.View[@resource-id="root"]/android.view.View/android.view.View/android.view.View/android.view.View[2]
${SOLICITAR_CRLV}   //android.widget.Button[@resource-id="veiculo-solicitar-documento"]
# xpath=//android.widget.Button[@text='veiculo-solicitar-documento']


*** Keywords ***
o usuario esteja logado no APP VEICULO
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    clicar no botao entrar

o usuario clica na opção VEÍCULO
    Wait Until Element Is Visible    ${VEICULO}  timeout=10s
    Click Element    ${VEICULO}

clicar na marca do veiculo
    Sleep    5s
    Wait Until Element Is Visible   ${MARCA_VEICULO}
    Click Element    ${MARCA_VEICULO}

clicar licenciamento anual do ano corrente
    Sleep    5s
    Swipe    500    500    500    1500    5000
    Wait Until Element Is Visible   ${LICENCIAMENTO_ANUAL}
    Click Element    ${LICENCIAMENTO_ANUAL}

o sitema exibira a modal com os debitos
    Wait Until Element Is Visible   ${VERIFICAR_DEBITO}  timeout=10s

################# SOLICITAR CRLV $$$$$$$$$$$$$$$$$$$$$$$

clicar na marca imagem veiculo
    Sleep    5s
    Wait Until Element Is Visible   ${MARCA_VEICULO}
    Click Element    ${MARCA_VEICULO}

# #clicar no solicitar CRLV
#     Sleep    2s
#     Capture Page Screenshot  tela_inicial.png
#     Sleep    2s
#     Swipe    500    1800    500    200    8000
#     Sleep    2s
#     Swipe    500    1500    500    200    6000

#     Wait Until Element Is Visible   ${SOLICITAR_CRLV}    timeout=10s
#     Switch To Context    WEBVIEW_stetho_com.google.android.apps.messaging
#     Click Element    xpath=//span[normalize-space(text())='Solicitar CRLV']



