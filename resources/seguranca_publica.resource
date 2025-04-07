*** Settings ***
Resource  ../common/main.resource

*** Variables ***
${SEGURANCA_PUBLICA}  //android.widget.TextView[@text="Segurança Pública"]
${CAMPO_BUSCAR}   //android.view.View[@text="Lista de Serviços | SYDLE APP"]/android.view.View/android.view.View[2]/android.view.View





*** Keywords ***
o usuario esteja logado no APP SEGURANÇA PUBLICA
    o usuario esteja na Home do APP
    o usuario clicar no botao entrarCom
    #clicar no botao entrar
    inserir o cpf ${USUARIO.CPF}
    inserir a senha ${USUARIO.PASSWORD}
    clicar no botao entrar
    Click Element    //android.widget.TextView[@text="Veja mais"]
    

o usuario clicar na opção SEGURANÇA PUBLICA
    Sleep    5s
    Wait Until Element Is Visible    ${SEGURANCA_PUBLICA}
    Click Element    ${SEGURANCA_PUBLICA}


o app exibirá as opçoes de servicos para os usuarios
    Wait Until Element Is Visible    ${CAMPO_BUSCAR}
    Sleep    5s
