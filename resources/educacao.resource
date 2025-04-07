*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${EDUCACAO}   //android.widget.TextView[@text="Educação"]
${MEUS_ALUNOS}  //android.widget.TextView[@text="Meus Alunos"]
${ANO_LETIVO}   //android.widget.TextView[@text="Selecione o ano letivo"]



*** Keywords ***
o usuario esteja logado no APP EDUCACAO
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    Hide Keyboard
    clicar no botao entrar
    clicar no botão permitir
    Capture Page Screenshot  tela_erro.png


o usuario clicar na opção EDUCACAO
    Wait Until Element Is Visible    ${EDUCACAO}
    Click Element   ${EDUCACAO}
    Capture Page Screenshot  tela.png
    

clicar na opçao meus alunos
    Wait Until Page Contains    ${MEUS_ALUNOS}
    #Click Element   ${MEUS_ALUNOS} 
    #Capture Page Screenshot  certidao_debito.png


o app exibirá o campo Selecione o ano letivo
    Sleep    1s
    Wait Until Element Is Visible   ${ANO_LETIVO} 
    
