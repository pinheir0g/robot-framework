*** Settings ***
Resource  ../resources/api_testing_usuarios.resource

*** Test Cases ***
Cenario 01: Cadastrar um novo usuário com sucesso na ServeRest
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Conferir se o usuario foi cadastrado corretamente


Cenario 02: Cadastrar um usuario ja existente na ServeRest
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Repetir o cadastro do usuario
    Verificar se a API não pemitiu o cadastro repetido


Cenario 03: Consultar os dados de um novo usuario
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest    email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Consultar os dados do novo usuario
    Conferir os dados retornados

Cenário 04: Logar com o novo usuário criado
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Realizar Login com o usuario  email=${EMAIL_TESTE}  password=1234
    Conferir se o Login ocorreu com sucesso

Cenário 05: Deletar um novo usuário com sucesso
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Deletar o usuário
    Verificar se o usuário foi deletado

Cenário 06: Editar um novo usuário com sucesso
    Criar um usuario novo
    Cadastrar o usuario criado na ServeRest  email=${EMAIL_TESTE}  adm=true  status_code_desejado=201
    Atualizar os dados do usuario
    Verificar se o dados foram atualizados com sucesso
 