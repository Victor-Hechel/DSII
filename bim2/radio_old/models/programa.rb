class Programa

	attr_accessor :id, :nome, :duracao, :inicio, :fim, :dia, :id_comunicador, :extensao

	def formaImagem()
		if extensao != ""
			return id.to_s + extensao
		else
			return 'padrao.jpg'
		end
	end
end