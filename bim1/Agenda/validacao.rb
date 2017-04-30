class Validacao

def self.numopcoes(selecionado, num_total)
	loop do
		if selecionado >=1 && selecionado <= num_total
		 	break
		else
			puts("\nInvalido! Digite novamente")
			selecionado = gets.to_i
		end
	end
	selecionado
end

def self.excluirCase(resposta)
	resposta.strip.downcase
	retorno = nil
	loop do
		if resposta == "s"
			retorno = true
		elsif resposta == "n"
			retorno = false
		else
			puts("\nInvalido! Digite novamente: ")
			resposta = gets.chomp.strip.downcase
		end
		break if retorno != nil
	end
	retorno
end

def self.validaNome(nome)
	nome.strip
	loop do
		if nome.length <= 3
			puts("O nome deve ter no minimo 4 caracteres! Digite novamente")
		elsif ContatoDAO.new.existeNome(nome)
			puts("Contato ja existe! Digite novamente:")
		else
			break
		end
		nome = gets.chomp.strip
	end
	nome
end

def self.validaTelefone(tel)
	tel.strip
	loop do
		if !(tel.match(/\([0-9]{2}\)9[0-9]{8}/) || tel.match(/[0-9]{2}9[0-9]{8}/) || tel.match(/\([0-9]{2}\)9[0-9]{4}-[0-9]{4}/))
			puts("Telefone invalido! Digite novamente: ")
		elsif ContatoDAO.new.existeTel(tel)
			puts("Telefone ja existe! Digite novamente: ")
		else
			break;
		end
		tel = gets.chomp.strip
	end
	tel
end

def self.validaEndereco(ende)
	ende.strip
	loop do
		if !(ende.length > 8 && ende.length <= 100)
			puts("Endereco invalido! Digite novamente: ")
			ende = gets.chomp.strip
		else
			break
		end
	end
	ende
end

end