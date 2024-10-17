*** Settings ***
Documentation    Tarefa de dicionarios modulo variaveis
*** Variables ***
&{MESES}    jan=31  fev=28  mar=31  abr=30  mai=31  jun=30  jul=31  ago=31  set=30  out=31  nov=30  dez=31

*** Test Cases ***
Caso de Teste 01 - imprimir valores do dicionario
    imprimir meses e dias do dicionario


*** Keywords ***
imprimir meses e dias do dicionario
    Log To Console    message=
    Log To Console    Jan: ${MESES.jan} dias
    Log To Console    Fev: ${MESES.fev} dias
    Log To Console    Mar: ${MESES.mar} dias
    Log To Console    Abr: ${MESES.abr} dias
    Log To Console    Mai: ${MESES.mai} dias
    Log To Console    Jun: ${MESES.jun} dias
    Log To Console    Jul: ${MESES.jul} dias
    Log To Console    Ago: ${MESES.ago} dias
    Log To Console    Set: ${MESES.set} dias
    Log To Console    Out: ${MESES.out} dias
    Log To Console    Nov: ${MESES.nov} dias
    Log To Console    Dez: ${MESES.dez} dias