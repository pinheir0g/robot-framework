*** Settings ***
Library  RequestsLibrary
Library    Collections

*** Keywords ***

Add product to cart
    [Arguments]  ${product_id}  ${amount}  ${expected_status_code}  ${token}=${None}

    ${HEADER_TOKEN}  Create Dictionary  Authorization=${token}
    ${product}  Create Dictionary  idProduto=${product_id}  quantidade=${amount}
    ${PRODUCTS}  Create List  ${product}
    ${BODY}  Create Dictionary  produtos=${PRODUCTS}
    Log  ${PRODUCTS}
    ${RESPONSE}  POST On Session  
    ...  alias=ServeRest  
    ...  url=/carrinhos  
    ...  headers=${HEADER_TOKEN}  
    ...  json=${BODY}  
    ...  expected_status=${expected_status_code}
    Set Test Variable  ${RESP_POST}  ${RESPONSE.json()}
    IF    ${RESPONSE.status_code} == 201
        Set Test Variable  ${ID_CART}  ${RESPONSE.json()["_id"]}
    END


Check that the cart has been created
    Dictionary Should Contain Item    dictionary=${RESP_POST}    key=message    value=Cadastro realizado com sucesso
    Dictionary Should Contain Item    dictionary=${RESP_POST}    key=_id    value=${ID_CART}

Consult the cart data
    ${RESPONSE_GET}  GET On Session  alias=ServeRest  url=/carrinhos/${ID_CART}
    Set Test Variable    ${RESP_GET_CART}  ${RESPONSE_GET.json()}

Check the cart data returned
    [Arguments]  ${proudct_id}

    ${price}  Convert To Integer  item=10000
    ${quantidade}  Convert To Integer  item=1

    ${BODY}  Create Dictionary  
    ...  idProduto=${proudct_id}  
    ...  quantidade=${quantidade}  
    ...  precoUnitario=${price}
    
    Log  ${RESP_GET_CART["produtos"][0]}


    Dictionary Should Contain Item    
    ...    dictionary=${RESP_GET_CART["produtos"][0]}
    ...    key=idProduto    
    ...    value=${proudct_id}

Complete purchase
    [Arguments]  ${token}=${None}

    ${HEADER_TOKEN}  Create Dictionary  Authorization=${token}
    ${RESPONSE_COMPLETE_CART}  DELETE On Session  
    ...  alias=ServeRest  
    ...  url=/carrinhos/concluir-compra
    ...  headers=${HEADER_TOKEN}
    ...  expected_status=200
    
    Set Test Variable  ${RESP_COMPLETE}  ${RESPONSE_COMPLETE_CART.json()}
Check if the purchase was completed successfully
    Dictionary Should Contain Item    dictionary=${RESP_COMPLETE}    key=message    value=Registro excluído com sucesso

Cancel a purchase
    [Arguments]  ${token}=${None}

    ${HEADER_TOKEN}  Create Dictionary  Authorization=${token}
    ${RESPONSE_DELETE_CART}  DELETE On Session  
    ...  alias=ServeRest
    ...  url=/carrinhos/cancelar-compra
    ...  headers=${HEADER_TOKEN}
    ...  expected_status=200

    Set Test Variable  ${RESP_DELETE}  ${RESPONSE_DELETE_CART.json()}
Check if the purchase was successfully canceled
    Dictionary Should Contain Item    
    ...    dictionary=${RESP_DELETE}    
    ...    key=message    
    ...    value=Registro excluído com sucesso. Estoque dos produtos reabastecido