require 'data_mapper'
require "dm-migrations"

DataMapper.setup(:default, "postgres://postgres:postgres@localhost/trabalhoHerois")

class Personagem

	include DataMapper::Resource
	property :id, Serial
	property :nome, String, :required => true
	property :nome_verdadeiro, String, :required => true
	property :type, Discriminator

	belongs_to :equipe
	has n, :habilidades, :through => Resource
end

class Habilidade

	include DataMapper::Resource
	property :id, Serial
	property :nome, String
	property :impacto, String
	property :descricao, String

	validates_length_of :descricao, :min => 10

	has n, :personagems, :through => Resource
end

class Equipe

	include DataMapper::Resource
	property :id, Serial
	property :nome, String

	has n, :personagems, :constraint => :destroy
end

class Heroi < Personagem
	property :fas, Integer
end

class Vilao < Personagem
	property :capangas, Integer
end

DataMapper.finalize

#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!