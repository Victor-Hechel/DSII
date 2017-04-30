class Contato

	attr_accessor :nome, :endereco, :id, :telefones

	def initialize(nome = nil, endereco = nil, telefones = [], id=nil)

		@nome = nome
		@telefones = telefones
		@endereco = endereco
		@id = id
	end

end