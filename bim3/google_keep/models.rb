require 'data_mapper'
require 'dm-migrations'

DataMapper.setup(:default, "postgres://postgres:postgres@localhost/googlekeep")

#Realizar o insert do usuário base:
#INSERT INTO usuarios VALUES(DEFAULT, 'Pessoa', 'admin', '12345', true);

class Usuario

	include DataMapper::Resource
	property :id, Serial
	property :nome, String
	property :login, String
	property :senha, String
	property :admin, Boolean

	has n, :anotacaos, :constraint => :destroy
end

class Anotacao

	include DataMapper::Resource
	property :id, Serial
	property :titulo, String
	property :descricao, String
	property :data, String
	property :hora, String

	belongs_to :usuario
end

DataMapper.finalize

#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!