require 'json'

class Comunicador

	attr_accessor :nome, :id, :programas, :extensao

	def formaImagem()
		if extensao != ""
			return id.to_s + extensao
		else
			return 'padrao.jpg'
		end	
	end
end