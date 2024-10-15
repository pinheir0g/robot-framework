*** Settings ***
Documentation    Tarefa para praticar loops 

Test Setup    Log To Console  ${\n}
*** Variables ***

@{NUMEROS}    1  2  3  4  5  6  7  8  9  10

*** Test Cases ***
Teste tarefa 6
    Percorre lista com FOR

*** Keywords ***
Percorre lista com FOR
    FOR    ${NUM}    IN    @{NUMEROS}
        IF  ${NUM} == 5
            Log    Eu sou o número 5!
            Log To Console    message=Eu sou o número 5!
        ELSE IF  ${NUM} == 10
            Log  Eu sou o número 10!
            Log To Console    message=Eu sou o número 10!
        ELSE
            Log  Eu não sou o número 5 e nem o 10!
            Log To Console    message=Eu não sou o número 5 e nem o 10!
        END
    END