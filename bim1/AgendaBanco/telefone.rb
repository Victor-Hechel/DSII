class Telefone

	attr_accessor :id, :numero, :id_contato

	def initialize(numero = nil, id = nil, id_contato = nil)
		@id = id
		@numero = numero
		@id_contato = id_contato
	end

end