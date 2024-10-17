*** Settings ***
Documentation  Suite test for endpoint /carrinhos API ServeRest
Resource  ../resources/api_testing_carrinho.resource
Resource    ../resources/api_testing_produtos.resource


*** Test Cases ***
Test Case 01: Successfully register a new cart
    Get authorization token
    Create a new product name
    Register a new product in ServeRest    
    ...  expected_status_code=201
    ...  token=${AUTH_TOKEN}

    Add product to cart  
    ...  product_id=${ID_PRODUCT}  
    ...  amount=1  
    ...  expected_status_code=201
    ...  token=${AUTH_TOKEN}

    Check that the cart has been created


Test Case 02: Register a new cart without Authentication Token Should be Blocked
    Get authorization token
    Create a new product name
    Register a new product in ServeRest    expected_status_code=201  token=${AUTH_TOKEN}
    Add product to cart  product_id=${ID_PRODUCT}  amount=1  expected_status_code=401
    Check that the API has not allowed registrations without Authentication

Test Case 03: Consult the data of a new cart
    Get authorization token
    Create a new product name
    Register a new product in ServeRest    expected_status_code=201  token=${AUTH_TOKEN}
    Add product to cart  product_id=${ID_PRODUCT}  amount=1  expected_status_code=201  token=${AUTH_TOKEN}
    Consult the cart data
    Check the cart data returned  ${ID_PRODUCT}

Test Case 04: Successfully completing a purchase
    Get authorization token
    Create a new product name
    Register a new product in ServeRest    expected_status_code=201  token=${AUTH_TOKEN}
    Add product to cart  product_id=${ID_PRODUCT}  amount=1  expected_status_code=201  token=${AUTH_TOKEN}
    Complete purchase  token=${AUTH_TOKEN}
    Check if the purchase was completed successfully


Test Case 05: Successfully canceling a purchase
    Get authorization token
    Create a new product name
    Register a new product in ServeRest    expected_status_code=201  token=${AUTH_TOKEN}
    Add product to cart  product_id=${ID_PRODUCT}  amount=1  expected_status_code=201  token=${AUTH_TOKEN}
    Cancel a purchase  token=${AUTH_TOKEN}
    Check if the purchase was successfully canceled