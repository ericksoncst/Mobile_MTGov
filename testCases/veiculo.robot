*** Settings ***
Resource    ../common/main.robot
Test Setup    Abrir app
Test Teardown   fechar app



*** Test Cases ***

Cenario 1 : Consulta VEICULO 
    [Tags]  VEICULO
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que o usuario esteja logado no APP VEICULO
    Quando o usuario clicar na opção VEÍCULO
    #E clicar no botao inicio