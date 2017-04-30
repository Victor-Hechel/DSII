class Contato

	attr_accessor :nome
	attr_accessor :telefone
	attr_accessor :endereco
	attr_accessor :id


def initialize(nome, telefone, endereco, id=nil)
	@nome = nome
	@telefone = telefone
	@endereco = endereco
	@id = id
end

end