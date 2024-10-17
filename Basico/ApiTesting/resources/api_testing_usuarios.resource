*** Settings ***
Library  RequestsLibrary
Library  String
Library    Collections


*** Keywords ***
Criar um usuario novo
    ${palavra_aleatoria}  Generate Random String  length=4  chars=[LETTERS]
    ${palavra_aleatoria}  Convert To Lower Case    ${palavra_aleatoria}
    Set Test Variable    ${EMAIL_TESTE}  ${palavra_aleatoria}@emailteste.com
    Log  ${EMAIL_TESTE}

Criar Sessao na ServeRest
    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev  headers=${headers}

Cadastrar o usuario criado na ServeRest
    [Arguments]    ${email}  ${adm}  ${status_code_desejado}
    ${body}  Create Dictionary   
        ...  nome=Fulano da Silva  
        ...  email=${email}  
        ...  password=1234  
        ...  administrador=${adm}

    Log  ${body}

    Criar Sessao na ServeRest

    ${response}  POST On Session  
    ...  alias=ServeRest  
    ...  url=/usuarios  
    ...  json=${body}
    ...  expected_status=${status_code_desejado}

    Log  ${response.json()}
    IF   ${response.status_code} == 201
        Set Test Variable   ${ID_USUARIO}  ${response.json()["_id"]}
    END
    Set Test Variable   ${RESPONSE}  ${response.json()}


Conferir se o usuario foi cadastrado corretamente
    Log  ${RESPONSE}
    Dictionary Should Contain Item  ${RESPONSE}  message  Cadastro realizado com sucesso
    Dictionary Should Contain Key    dictionary=${RESPONSE}    key=_id

Repetir o cadastro do usuario
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=400

Verificar se a API não pemitiu o cadastro repetido
    Dictionary Should Contain Item    dictionary=${RESPONSE}    key=message    value=Este email já está sendo usado


Consultar os dados do novo usuario
    ${RESPONSE_GET}  GET On Session  alias=ServeRest  url=/usuarios/${ID_USUARIO}
    Set Test Variable  ${RESP_GET}  ${RESPONSE_GET.json()}

Conferir os dados retornados
    Log  ${RESP_GET}
    Dictionary Should Contain Item   ${RESP_GET}    nome            Fulano da Silva
    Dictionary Should Contain Item   ${RESP_GET}    email           ${EMAIL_TESTE}
    Dictionary Should Contain Item   ${RESP_GET}    password        1234
    Dictionary Should Contain Item   ${RESP_GET}    administrador   true
    Dictionary Should Contain Item   ${RESP_GET}    _id             ${ID_USUARIO}


Realizar Login com o usuario
    [Arguments]  ${email}  ${password}
     ${BODY}  Create Dictionary    
        ...  email=${email}  
        ...  password=${password}

    ${RESPONSE_LOGIN}  POST On Session  
    ...    alias=ServeRest    
    ...    url=/login
    ...    json=${BODY}
    ...    expected_status=200 

    Log  ${BODY}
    Set Test Variable  ${RESP_LOGIN}  ${RESPONSE_LOGIN.json()}


Conferir se o Login ocorreu com sucesso
    Log  ${RESP_LOGIN}
    Dictionary Should Contain Item    dictionary=${RESP_LOGIN}    key=message   value=Login realizado com sucesso
    Dictionary Should Contain Key    dictionary=${RESP_LOGIN}    key=authorization


Deletar o usuário
    ${RESPONSE_DELETE}  DELETE On Session  alias=ServeRest  url=/usuarios/${ID_USUARIO}
    Set Test Variable    ${RESP_JSON}  ${RESPONSE_DELETE.json()}

Verificar se o usuário foi deletado
    Dictionary Should Contain Item    dictionary=${RESP_JSON}    key=message    value=Registro excluído com sucesso


Atualizar os dados do usuario
    ${NEW_BODY}  Create Dictionary  
    ...  nome=Fulano da Costa   
    ...  email=${EMAIL_TESTE}
    ...  password=12345  
    ...  administrador=false
      
    ${RESPONSE_PUT}  PUT On Session  alias=ServeRest  url=usuarios/${ID_USUARIO}  json=${NEW_BODY}  expected_status=200

    Set Test Variable  ${RESP_JSON}  ${RESPONSE_PUT.json()}
    Set Test Variable  ${BODY}  ${NEW_BODY}


Verificar se o dados foram atualizados com sucesso
    Log  ${BODY}
    Dictionary Should Contain Item    dictionary=${RESP_JSON}    key=message    value=Registro alterado com sucesso
    Consultar os dados do novo usuario
    Log  ${RESP_GET}
    Dictionary Should Contain Item   ${RESP_GET}    nome            ${BODY.nome}
    Dictionary Should Contain Item   ${RESP_GET}    email           ${BODY.email}
    Dictionary Should Contain Item   ${RESP_GET}    password        ${BODY.password}
    Dictionary Should Contain Item   ${RESP_GET}    administrador   ${BODY.administrador}
    Dictionary Should Contain Item   ${RESP_GET}    _id             ${ID_USUARIO}