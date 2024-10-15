*** Settings ***
Library  RequestsLibrary
Resource    api_testing_usuarios.resource


*** Variables ***


*** Keywords ***

Get authorization token
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Realizar Login com o usuario  email=${EMAIL_TESTE}  password=1234
    Set Test Variable  ${AUTH_TOKEN}  ${RESP_LOGIN["authorization"]}
    Log  ${AUTH_TOKEN}


Get authorization token for non-adm
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=false  status_code_desejado=201
    Realizar Login com o usuario  email=${EMAIL_TESTE}  password=1234
    Set Test Variable  ${AUTH_TOKEN}  ${RESP_LOGIN["authorization"]}
    Log  ${AUTH_TOKEN}
    
Create a new product name
    ${random_product}  Generate Random String  length=6  chars=[LETTERS]
    ${random_product}  Convert To Lower Case    ${random_product}
    Set Test Variable    ${product_name}  Produto: ${random_product}
    Log  ${product_name}

Register a new product in ServeRest
    [Arguments]  ${expected_status_code}  ${token}=${None}

    ${body}  Create Dictionary  nome=${product_name}  preco=10000  descricao=Celular  quantidade=10
    ${HEADER_TOKEN}  Create Dictionary  Authorization=${token}
    ${RESPONSE}  POST On Session  alias=ServeRest  url=/produtos  headers=${HEADER_TOKEN}  json=${body}   expected_status=${expected_status_code}
    Set Test Variable  ${RESP_POST}  ${RESPONSE.json()}
    IF    ${RESPONSE.status_code} == 201
        Set Test Variable    ${ID_PRODUCT}  ${RESPONSE.json()["_id"]}
    END

Check that the product has been successfully registered
    Dictionary Should Contain Item    dictionary=${RESP_POST}    key=message    value=Cadastro realizado com sucesso
    
Repeat product register
    Register a new product in ServeRest  expected_status_code=400  token=${AUTH_TOKEN}

Check that the API has not allowed repeated registrations
    Dictionary Should Contain Item    dictionary=${RESP_POST}    key=message    value=Já existe produto com esse nome

Check that the API has not allowed registrations without Authentication
    Dictionary Should Contain Item    dictionary=${RESP_POST}    key=message    value=Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Check that the API has not allowed registrations of products for non-Administrators
    Dictionary Should Contain Item    dictionary=${RESP_POST}    key=message    value=Rota exclusiva para administradores

Consult the new product data
    ${RESPONSE_GET}  GET On Session  alias=ServeRest  url=/produtos/${ID_PRODUCT}
    Set Test Variable  ${RESP_GET_PRODUTC}  ${RESPONSE_GET.json()}

 Check the data returned
    Log  ${RESP_GET_PRODUTC}
    ${price}  Convert To Integer    item=10000
    ${quantidade}  Convert To Integer  item=20
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=nome    value=${product_name}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=preco    value=${price}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=descricao   value=Celular
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=quantidade    value=${quantidade}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=_id    value=${ID_PRODUCT}


Delete a product
    [Arguments]  ${expected_status_code}  ${token}=${None}
    ${HEADER_TOKEN}  Create Dictionary   Authorization=${token}
    ${RESPONSE_DELETE_PROD}  DELETE On Session  alias=ServeRest  url=/produtos/${ID_PRODUCT}  headers=${HEADER_TOKEN}
    Set Test Variable  ${RESP_DELETE_PROD}  ${RESPONSE_DELETE_PROD.json()}

Check if the product has been deleted
    Dictionary Should Contain Item    dictionary=${RESP_DELETE_PROD}    key=message    value=Registro excluído com sucesso

Update product data
    [Arguments]  ${expected_status_code}  ${token}=${None}

    ${HEADER_TOKEN}  Create Dictionary   Authorization=${token}
    ${BODY}  Create Dictionary  nome=${product_name}  preco=90000  descricao=Celular  quantidade=19
    ${RESPONSE_PUT}  PUT On Session  alias=ServeRest  url=/produtos/${ID_PRODUCT}  json=${BODY}  expected_status=${expected_status_code}   headers=${HEADER_TOKEN}
    Set Test Variable  ${RESP_JSON}  ${RESPONSE_PUT.json()}
    Set Test Variable    ${UPDATED_BODY}  ${BODY}


Check that the data has been updated successfully
    Dictionary Should Contain Item    dictionary=${RESP_JSON}    key=message    value=Registro alterado com sucesso
    Consult the new product data
    ${price}  Convert To Integer    item=${UPDATED_BODY.preco}
    ${quantidade}  Convert To Integer  item=${UPDATED_BODY.quantidade}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=nome    value=${UPDATED_BODY.nome}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=preco    value=${price}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=descricao   value=Celular
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=quantidade    value=${quantidade}
    Dictionary Should Contain Item    dictionary=${RESP_GET_PRODUTC}    key=_id    value=${ID_PRODUCT}

