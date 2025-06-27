*** Settings ***
Resource  ../common/main.resource


*** Variables ***
${CNH}  //android.widget.TextView[@text="CNH"]
${RENOVACAO_EXAMES}   //android.widget.Button[@text="Solicitar renovação de CNH Renova o vencimento da Carteira Nacional de Habilitação"]
${ANDAMENTO_RENOVACAO}  //android.widget.TextView[@text="Solicitar Renovação da Carteira Nacional de Habilitação - CNH"]
${RENOVACAO_CNH}  //android.widget.TextView[@text="Solicitar renovação de CNH"]
${RENOVACAO_CARTEIRA}  //*[(contains(@text, "Solicitar renovação de CNH"))]
${ACESSAR_SERVICO}    //android.widget.Button[@resource-id="cnh-carta-servico-acessar"]
${SOLICITAR_SEGUNDA_VIA}   //android.widget.Button[@text="Solicitar segunda via de CNH Reemite a segunda via da sua Carteira Nacional de Habilitação"]
${EDITAR_CONTATO}  //android.view.View[@text="EDITAR"]
${SALVAR_CONTATO}  //android.widget.Button[@text="SALVAR"]
${BTN_CONTINUAR}    //android.widget.Button[@resource-id="cnh-processo-continuar"]
${DADOS_CONDUTOR}  //android.widget.TextView[@text="Dados pessoais"]
${BOTAO_CONTINUAR_PCD}  //android.widget.Button[@resource-id="cnh-processo-continuar"]
${BOTAO_ATIVIDADE_REMUNERADO}   //android.widget.Button[@resource-id="cnh-processo-continuar"]
${BOTAO_CONTINUAR_FOTO}  //android.widget.Button[@resource-id="cnh-processo-continuar"]
${ADICIONAR_UNIDADE}  //android.widget.Button[@text="ADICIONAR UNIDADE"]
${SELECIONAR_UNIDADE}  //android.app.Dialog/android.view.View/android.widget.RadioButton[1]
${BOTAO_CONTINUAR_UNIDADE}  (//android.widget.Button[@text="CONTINUAR"])[2]
${BOTAO_CONTINUAR_INFORMACOES}  //android.widget.Button[@resource-id="cnh-processo-continuar"]

*** Keywords ***
o usuario esteja logado no APP MT_CIDADAO CNH
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    Sleep    5s
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir


o usuario clicar na opção CNH
    Wait Until Element Is Visible  ${CNH}
    Click Element    ${CNH}

clicar na opção RENOVACAO DE EXAMES
    Sleep    5s
    Wait Until Element Is Visible   //android.view.View[@resource-id="root"]/android.widget.Image
    Swipe    500    1500    500    500    5000
    Wait Until Element Is Visible   ${RENOVACAO_EXAMES}
    Click Element   ${RENOVACAO_EXAMES}
    Capture Page Screenshot  segunda_via.png


o app exibirá o texto andamento da renovacao de exames
    Swipe    500    500    500    1500    5000
    Wait Until Element Is Visible    ${ANDAMENTO_RENOVACAO}
    Capture Page Screenshot  solicitar_agendamento.png


###  Consulta  RENOVAÇÃO CNH  ###########################################
clicar na opcao renovacao de carteira
    Sleep    5s
    Wait Until Element Is Visible    //android.view.View[@resource-id="root"]/android.widget.Image  timeout=20s
    Swipe    500    1500    500    500    5000
    Wait Until Element Is Visible    ${RENOVACAO_CARTEIRA}
    Click Element    ${RENOVACAO_CARTEIRA}

clicar no botão acessar o servico
    Swipe    500    1900    500    100    1000
    Swipe    500    1900    500    100    1000
    Swipe    500    1900    500    100    1000
    Wait Until Element Is Visible    ${ACESSAR_SERVICO}
    Click Element    ${ACESSAR_SERVICO}

clicar no botão editar contato renovacao
    Sleep    5s
    #Wait Until Element Is Visible    //android.widget.TextView[@text="Dados do condutor"]
    Wait Until Element Is Visible    ${EDITAR_CONTATO} 
    Click Element    ${EDITAR_CONTATO}
    
inserir o email renovacao
    Sleep    6s
    #Wait Until Element Is Visible    //android.widget.TextView[@text="Atualizar Contato"]
    Wait Until Element Is Visible  //android.widget.EditText[@resource-id=":r6:"]
    Click Element  //android.widget.EditText[@resource-id=":r6:"]
    # Input Text   //android.widget.EditText[@resource-id=":r7:"]    nereuc@gmail.com
     
clicar no botão salvar contato
    #Wait Until Element Is Visible    //android.widget.TextView[@text="Atualizar Contato"]
    Swipe    500    1500    500    500    1000
    Swipe    500    1500    500    500    1000
    Swipe    500    1500    500    500    1000
    Wait Until Element Is Visible    ${SALVAR_CONTATO}
    Click Element    ${SALVAR_CONTATO}

clicar no botão continuar
    #Wait Until Element Is Visible    //android.widget.TextView[@text="Dados do condutor"]
    Swipe    500    1900    500    100    1000
    Swipe    500    1900    500    100    1000
    Wait Until Element Is Visible    ${BTN_CONTINUAR}
    Click Element    ${BTN_CONTINUAR}

clicar no botão continuar PCD
    Sleep    10s
    #Wait Until Element Is Visible    (//android.widget.TextView[@text="CNH PcD"])[2]
    Wait Until Element Is Visible    ${BOTAO_CONTINUAR_PCD}   timeout=5
    Click Element    ${BOTAO_CONTINUAR_PCD}
    

clicar no botão continuar Atividade Remunerada
    Wait Until Element Is Visible    (//android.widget.TextView[@text="Atividade Remunerada"])[2]
    Sleep    10s
    Swipe    500    1600    500    400    1000
    Swipe    500    1900    500    100    1000
    Wait Until Element Is Visible    ${BOTAO_ATIVIDADE_REMUNERADO}
    Click Element    ${BOTAO_ATIVIDADE_REMUNERADO}
    Capture Page Screenshot  atividade.png
    Log Source


clicar no botão continuar foto
    Wait Until Element Is Visible    //android.widget.TextView[@text="Foto do condutor"]
    Swipe    500    1900    500    100    1000
    Swipe    500    1900    500    100    1000
    Sleep    5s
    Wait Until Element Is Visible    ${BOTAO_CONTINUAR_FOTO}    timeout=5s
    Click Element    ${BOTAO_CONTINUAR_FOTO}
    Capture Page Screenshot   foto.png
    Log Source


clicar na opção adicionar unidade
    Wait Until Element Is Visible    (//android.widget.TextView[@text="Outras Informações"])[2]
    Wait Until Element Is Visible   ${ADICIONAR_UNIDADE}
    Click Element    ${ADICIONAR_UNIDADE}
    Capture Page Screenshot   adicionar_unidade.png

clicar na opção selecionar unidade
    Wait Until Element Is Visible    //android.widget.TextView[@text="Unidades de atendimento"]
    Wait Until Element Is Visible   ${SELECIONAR_UNIDADE}
    Click Element   ${SELECIONAR_UNIDADE}

clicar no botão continuar unidade
    Swipe    500    1500    500    500    1000
    Wait Until Element Is Visible  ${BOTAO_CONTINUAR_UNIDADE}
    Click Element    ${BOTAO_CONTINUAR_UNIDADE}

clicar no botão continuar Informações
    Wait Until Element Is Visible    (//android.widget.TextView[@text="Outras Informações"])[2]
    Swipe    500    1500    500    500    1000
    Wait Until Element Is Visible  ${BOTAO_CONTINUAR_INFORMACOES}
    Click Element    ${BOTAO_CONTINUAR_INFORMACOES}
     
  
####  SOLICITAR SEGUNDA VIA ################
clicar na opcao solicitar segunda via
    Sleep    5s
    Wait Until Element Is Visible   //android.view.View[@resource-id="root"]/android.widget.Image  timeout=20s
    Swipe    500    1500    500    500    1000
    Wait Until Element Is Visible    ${SOLICITAR_SEGUNDA_VIA}
    Click Element    ${SOLICITAR_SEGUNDA_VIA}

clicar no botão editar contato
    Wait Until Element Is Visible   ${EDITAR_CONTATO}
    Click Element   ${EDITAR_CONTATO}

inserir o email
    Sleep    5s
    Wait Until Element Is Visible   //android.widget.EditText[@resource-id=":r9:"]
    Click Element  //android.widget.EditText[@resource-id=":r9:"]
    Input Text   //android.widget.EditText[@resource-id=":r9:"]   nereu.nogueira@xvia.com.br
    Click Element    //android.widget.Button[@text="SALVAR"]
    Sleep    5s

o app exibirá a tela Dados dos Condutor
    Sleep    5s
    Wait Until Element Is Visible   ${DADOS_CONDUTOR}


# clicar no botao continuar
#     Sleep    5s
#     Swipe    500    1900    500    100    1000
#     #Wait Until Element Is Visible  ${BTN_CONTINUAR}
#     Click Element    xpath=//android.widget.Button[contains(@resource-id, 'processo-continuar')]
 


            