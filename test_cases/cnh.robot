*** Settings ***
Resource    ../common/main.resource
Test Setup    Setup Com Login  usuario_login=&{USUARIO}
Test Teardown   fechar app

Test Tags  cnh


*** Test Cases ***
Cenario 1 : Consultar CNH
    [Tags]  consulta_cnh
    Dado que vejo o painel do cidadão logado
    Quando o usuario clicar na opção CNH
    E clicar na opção RENOVACAO DE EXAMES
    Então o app exibirá o texto andamento da renovacao de exames

Cenario 2: Solicitar Renovação de Exame
    [Tags]  renovacao_cnh
    Dado que vejo o painel do cidadão logado
    Quando o usuario clicar na opção CNH
    E clicar na opcao renovacao de carteira
    E clicar no botão acessar o servico
    E clicar no botão editar contato renovacao
    #E inserir o email renovacao
    E clicar no botão salvar contato
    E clicar no botão continuar
    E clicar no botão continuar PCD
    E clicar no botão continuar Atividade Remunerada
    E clicar no botão continuar foto
    E clicar na opção adicionar unidade
    E clicar na opção selecionar unidade
    E clicar no botão continuar unidade
    E clicar no botão continuar Informações
    

Cenario 3: Solicitar segunda via de CNH
    [Tags]  segunda_via
    VAR  ${letra}    ${USUARIO.NAME}[0:1]    scope=TEST
    Dado que vejo o painel do cidadão logado
    E o usuario clicar na opção CNH
    Quando clicar na opcao solicitar segunda via
    E clicar no botão editar contato
    E inserir o email
    #E clicar no botao continuar
    Então o app exibirá a tela Dados dos Condutor
