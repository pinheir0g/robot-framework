*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    http://www.amazon.com.br
${LOGO_AMAZON}     nav-logo-sprites
${MENU_ELETRONICOS}    //a[@href='/Eletronicos-e-Tecnologia/b/?ie=UTF8&node=16209062011&ref_=nav_cs_electronics'][contains(.,'Eletrônicos')]
${HEADER_ELETRONICOS}    //h1[contains(.,'Ofertas em Eletrônicos e Tecnologia | Esquenta Mega Oferta')]
${CAMPO_PESQUISA}    field-keywords
${SEARCH_BUTTON}    nav-search-submit-button
${XBOX_IMG}    //img[contains(@alt,'Console Xbox Series S')]
${PRODUTO_CART_NAME}    //span[@class='a-truncate-cut'][contains(.,'Console Xbox Series S')]
${EXCLUIR_BUTTON}    //input[@value='Excluir']
${CARRINHO_VAZIO}    //h2[contains(.,'Seu carrinho de compras da Amazon está vazio.')]
${DELETE_SUCCESS}    NATC_SMART_WAGON_CONF_MSG_SUCCESS


*** Keywords ***
Abrir o navegador
    Open Browser    browser=Chrome    options=add_experimental_option("detach", True)
    Maximize Browser Window

Fechar o navegador
    Close Browser


Acessar a home page do site Amazon.com.br
    Go To    url=${URL}
    Wait Until Element Is Visible    locator=${LOGO_AMAZON}

Entrar no menu "Eletrônicos"
    Click Element    locator=${MENU_ELETRONICOS}

Verificar se aparece a frase "${FRASE}"
    Wait Until Page Contains    text=${FRASE}
    Wait Until Element Is Visible    locator=${HEADER_ELETRONICOS} 

Verificar se o título da página fica "${TITULO}"
    Title Should Be    title=${TITULO}


Verificar se aparece a categoria "${NOME_CATEGORIA}"
    Element Should Be Visible    locator=//img[contains(@alt,'${NOME_CATEGORIA}')]


Digitar o nome de produto "${PRODUTO}" no campo de pesquisa
    Input Text    locator=${CAMPO_PESQUISA}      text=${PRODUTO}

Clicar no botão de pesquisa
    Click Button    locator=${SEARCH_BUTTON}

Verificar se o resultado da pesquisa esta listando o produto "${PRODUTO}"
    Wait Until Element Is Visible    locator=//span[@class='a-size-base-plus a-color-base a-text-normal'][contains(.,'${PRODUTO}')]


Adicionar o produto "Console Xbox Series S" no carrinho
    Click Element    locator=${XBOX_IMG}
    Click Button    locator=add-to-cart-button
    Wait Until Element Is Visible    locator=${DELETE_SUCCESS} 

Verificar se o produto "${PRODUTO}" foi adicionado com sucesso
    Click Element    locator=nav-cart
    Wait Until Element Is Visible    locator=${PRODUTO_CART_NAME}
    Element Text Should Be    locator=${PRODUTO_CART_NAME}    expected=${PRODUTO}


Remover o produto "Console Xbox Series S" do carrinho
    # Wait Until Element Is Visible    locator=${EXCLUIR_BUTTON}
    Click Button     locator=${EXCLUIR_BUTTON}

Verificar se o carrinho fica vazio
    Wait Until Element Is Visible    locator=${CARRINHO_VAZIO} 
    Element Text Should Be    locator=${CARRINHO_VAZIO}     expected=Seu carrinho de compras da Amazon está vazio.


# GHERKING BDD STEPS

Dado que estou na home page da Amazon.com.br
    Acessar a home page do site Amazon.com.br
    Verificar se o título da página fica "Amazon.com.br | Tudo pra você, de A a Z."

Quando acessar o menu "Eletrônicos"
    Entrar no menu "Eletrônicos"

Então o título da página deve ficar "Eletrônicos e Tecnologia | Amazon.com.br"
    Verificar se o título da página fica "Eletrônicos e Tecnologia | Amazon.com.br"

E o texto "Eletrônicos e Tecnologia" deve ser exibido na página
    Verificar se aparece a frase "Ofertas em Eletrônicos e Tecnologia"
    
E a categoria "Computadores e Informática" deve ser exibida na página
    Verificar se aparece a categoria "Computadores e Informática"

Quando pesquisar pelo produto "Xbox Series S"
    Digitar o nome de produto "Xbox Series S" no campo de pesquisa
    Clicar no botão de pesquisa

Então o título da página deve ficar "Amazon.com.br : Xbox Series S"
    Verificar se o título da página fica "Amazon.com.br : Xbox Series S"

E um produto da linha "Xbox Series S" deve ser mostrado na página
    Verificar se o resultado da pesquisa esta listando o produto "Console Xbox Series S"


Quando adicionar o produto "${PRODUTO}" no carrinho
    Digitar o nome de produto "${PRODUTO}" no campo de pesquisa
    Clicar no botão de pesquisa
    Verificar se o resultado da pesquisa esta listando o produto "${PRODUTO}"
    Adicionar o produto "Console Xbox Series S" no carrinho

Então o produto "${PRODUTO}" deve ser mostrado no carrinho
    Verificar se o produto "${PRODUTO}" foi adicionado com sucesso

E existe o produto "${PRODUTO}" no carrinho
    Quando adicionar o produto "${PRODUTO}" no carrinho
    Verificar se o produto "${PRODUTO}" foi adicionado com sucesso

Quando remover o produto "Console Xbox Series S" do carrinho
    Remover o produto "Console Xbox Series S" do carrinho

Então o carrinho deve ficar vazio
    Verificar se o carrinho fica vazio