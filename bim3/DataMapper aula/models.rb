require 'data_mapper' 
require 'dm-migrations'

#IMPORTANTE: criar o database antes de executar o código


#equivalente ao PG.connect
DataMapper.setup(:default, "postgres://postgres:postgres@localhost/aula")
# "<SGBD>://<USER>:<PASSWORD>@<HOST>/<DATABASE>"

class Professor
	#cria os atributos e ao mesmo tempo configura o CREATE TABLE
	include DataMapper::Resource
	property :id, Serial
	property :nome, String
	property :apelido, String
end

# finaliza as declarações de atributo
DataMapper.finalize



# migrate e upgrade convertem os modelos para sql e ambos criam a tabela sozinhos


#migrate da drop na tabela caso tenha alguma mudança nos atributos do modelo e cria uma nova
#DataMapper.auto_migrate!

#upgrade faz a mesma coisa que o migrate porém não exclui
#as tabelas antigas quando há mudança, só as atualiza
DataMapper.auto_upgrade!