*** Settings ***
Documentation  Tests for products endpoints in ServeRest
Resource  ../resources/api_testing_produtos.resource
Test Setup  Criar Sessao na ServeRest

*** Test Cases ***

Test Case 01: Successfully register a new product in ServeRest
    Get authorization token  
    Create a new product name
    Register a new product in ServeRest  expected_status_code=201  token=${AUTH_TOKEN}
    Check that the product has been successfully registered

Test Case 02: Register an existing product
    Get authorization token  
    Create a new product name
    Register a new product in ServeRest  expected_status_code=201  token=${AUTH_TOKEN}
    Repeat product register
    Check that the API has not allowed repeated registrations
    
Teste Case 03: Product Registration Without Authentication Should Be Blocked
    Create a new product name
    Register a new product in ServeRest  expected_status_code=401
    Check that the API has not allowed registrations without Authentication


Test Case 04: Product Registration Should Only Be Allowed for Administrators
     Get authorization token for non-adm
     Create a new product name
     Register a new product in ServeRest  expected_status_code=403  token=${AUTH_TOKEN}
     Check that the API has not allowed registrations of products for non-Administrators

Test Case 05: Consult the data of a new product
    Get authorization token
    Create a new product name
    Register a new product in ServeRest  expected_status_code=201  token=${AUTH_TOKEN}
    Consult the new product data
    Check the data returned


Teste Case 06: Successfully deleting a new product
    Get authorization token
    Create a new product name
    Register a new product in ServeRest  expected_status_code=201  token=${AUTH_TOKEN}
    Delete a product  expected_status_code=200  token=${AUTH_TOKEN}
    Check if the product has been deleted

Test Case 07: Successfully update a new product 
    Get authorization token
    Create a new product name
    Register a new product in ServeRest  expected_status_code=201  token=${AUTH_TOKEN}
    Update product data  expected_status_code=200  token=${AUTH_TOKEN}
    Check that the data has been updated successfully


