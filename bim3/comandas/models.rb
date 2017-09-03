require 'data_mapper'
require 'dm-migrations'

DataMapper.setup(:default, "postgres://postgres:postgres@localhost/guiche")

class Produto

	include DataMapper::Resource
	property :id, Serial
	property :nome, String
	property :preco, Float

	has n, :items, :constraint => :destroy
end

class Cliente

	include DataMapper::Resource
	property :id, Serial
	property :cpf, Integer
	property :nome, String

	has n, :comandas, :constraint => :destroy

end

class Garcom

	include DataMapper::Resource
	property :id, Serial
	property :cpf, Integer
	property :nome, String
	property :dataIngresso, Date
	property :dataDesligamento, Date

	has n, :comandas, :constraint => :destroy

end

class Comanda

	include DataMapper::Resource
	property :id, Serial
	property :abertura, Time
	property :encerramento, Time

	belongs_to :cliente
	belongs_to :garcom
	has n, :items, :constraint => :destroy
end

class Item

	include DataMapper::Resource
	property :id, Serial
	property :quantidade, Integer

	belongs_to :comanda
	belongs_to :produto

end

DataMapper.finalize

DataMapper.auto_upgrade!