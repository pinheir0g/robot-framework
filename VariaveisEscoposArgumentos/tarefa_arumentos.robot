*** Settings ***
Documentation     Tarefa para praticar keywords com argumentos
Library    String

*** Test Cases ***
Caso de Teste 01
    ${EMAIL}    Criar email costumizado    $NOME=Gustavo    $SOBRENOME=Pinheiro
    Log To Console    message=${EMAIL}
    

*** Keywords ***
Criar email costumizado
    [Arguments]    ${NOME}    ${SOBRENOME}
    ${RANDOM_WORD}    Generate Random String
    ${EMAIL}   Set Variable    ${NOME}${SOBRENOME}${RANDOM_WORD}@testerobot.com
    [Return]    ${EMAIL}
