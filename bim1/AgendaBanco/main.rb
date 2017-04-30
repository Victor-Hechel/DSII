require_relative "contato.rb"
require_relative "contatoDAO.rb"
require_relative "validacao.rb"


tel = "(53)924885383838"

puts(tel.scan(/\([0-9]{2}\)9[0-9]{8}/) || tel.scan(/[0-9]{2}9[0-9]{8}/) || tel.scan(/\([0-9]{2}\)9[0-9]{4}-[0-9]{4}/))

#tela de cadastro

def adicionarContato
	puts("--------------------------------\nDigite o nome:")
	nome = Validacao.validaNome(gets.chomp)
	puts("Digite o telefone:")
	telefone = Validacao.validaTelefone(gets.chomp)
	puts("Digite o endereco:")
	endereco = Validacao.validaEndereco(gets.chomp)
	contato = Contato.new(nome, endereco, [Telefone.new(telefone)])
	ContatoDAO.new.salvar(contato)
end

#menu da lista de contatos

def listarContatos
		
	escolha = 1
	contatos = []
	loop do
		contatos = ContatoDAO.new.listar
		puts("--------------------------------\nContatos:\n--------------------------------")

		if contatos.size == 0
			puts("\nVocê nao possui contatos!\n\n")
			break
		else

			lista(contatos)

			puts("\n\n#{contatos.size+1}. Pesquisar contatos:\n#{contatos.size+2}. Exportar contatos para arquivo HTML\n#{contatos.size+3}. Sair")


			puts("\nDigite o numero do contato que deseja ver:")
			escolha = Validacao.numopcoes(gets.to_i, contatos.size+3)

			if (escolha >= 1 && escolha <= contatos.size)
				abrirContato(contatos[escolha-1])
			elsif (escolha == contatos.size+1)
				pesquisa
			elsif (escolha == contatos.size+2)
				toHTML(contatos)
			end
		end
	break if escolha == contatos.size+3
	end
end

#lista os contatos na tela

def lista(contatos)
	for i in 0..contatos.size-1
		puts ("#{i+1}. #{contatos[i].nome}")
		i = i + 1
	end
end

#tela de pesquisa de contatos

def pesquisa

	loop do
		puts("\n\nDigite o nome do contato o 1 para sair: ")
		nome = gets.chomp.strip.downcase
		if nome == "1"
			break
		end
		escolha = nil
		contatos = []
		loop do
			contatos = ContatoDAO.new.listarbyName(nome)
			puts("\n\nResultados da pesquisa:\n\n")

			if contatos.size == 0
				puts("Contatos nao encontrados!")
				break
			end

			lista(contatos)

			puts("\n\n#{contatos.size+1}. Exportar contatos para arquivo HTML\n#{contatos.size+2}. Voltar\n")
			puts("Digite sua acao: ")

			escolha = Validacao.numopcoes(gets.to_i, contatos.size+2)

			if (escolha >= 1 && escolha <= contatos.size)
				abrirContato(contatos[escolha-1])
			elsif escolha == contatos.size+1
				toHTML(contatos)
			end
				
		break if (escolha == contatos.size+2)
		end
	break if (escolha == contatos.size+2)
	end
end

#transforma os contatos em HTML

def toHTML(contatos)

	puts("\n\nTem certeza que deseja exportar a lista de contatos para um arquivo HTML? S/N: ")

	if Validacao.excluirCase(gets.chomp)
		ContatoDAO.new.toHTML(contatos)
		puts("\n\nLista exportada com sucesso!\nDeseja abrir o arquivo? S/N: ")
		if Validacao.excluirCase(gets.chomp)
			system("firefox lista.html&")
		end
	end

end

#mostra os dados do contato

def abrirContato(contato)

	loop do
		puts("--------------------------------\nContato:\n--------------------------------")
		puts("Nome: #{contato.nome}\nEndereco: #{contato.endereco}\nTelefones: \n")
		for tel in contato.telefones
			puts("#{tel.numero}")
		end
		puts("\n1.Editar\n2.Excluir\n3.Adicionar Numero\n4.Excluir um numero\n5.Voltar")
		puts("Digite sua acao:")

		escolha = Validacao.numopcoes(gets.to_i, 5);

		case escolha
		when 1
			editar(contato)
		when 2
			excluir(contato)
		when 3
			addTelefone(contato)
		when 4
			excluirTelefone(contato.telefones)
		end
	break if (escolha == 2 || escolha == 5)
	end
end

#tela de excluir telefones

def excluirTelefone(telefones)

	puts("--------------------------------\nTelefones:\n--------------------------------")
	for i in 0..telefones.size-1
		puts("#{i+1}. #{telefones[i].numero}")
	end

	puts("\nDigite o numero que deseja excluir: ")
	escolha = Validacao.numopcoes(gets.to_i, telefones.size);

	puts("Tem certeza que deseja excluir esse telefone? S/N: ")
	if Validacao.excluirCase(gets.chomp)
		ContatoDAO.new.excluirTelefone(telefones[escolha-1].id)
		puts("Contato excluido com sucesso!")
		telefones.delete_at(escolha-1);
	end

end

#cadastro de um novo numero

def addTelefone(contato)
	puts("\n\nDigite o novo numero:")
	tel = Telefone.new
	tel.numero = Validacao.validaTelefone(gets.chomp)
	tel.id_contato = contato.id
	contato.telefones.push(tel)
	ContatoDAO.new.addTelefone(tel)
end

#menu de edição do contato

def editar(contato)
	dao = ContatoDAO.new
	loop do

		puts("--------------------------------\nEditar:\n--------------------------------")
		puts("1.Nome: #{contato.nome}\n2.Endereco: #{contato.endereco}\n         Telefone           \n")
		for i in 0..contato.telefones.size-1
			puts("#{i+3}. #{contato.telefones[i].numero}")
		end

		puts("#{contato.telefones.size+3}. Voltar\n")

		puts("Digite o que deseja alterar:")

		escolha = Validacao.numopcoes(gets.to_i, contato.telefones.size+3)

		case escolha
		when 1
			puts("\n\nDigite o novo nome:")
			nome = Validacao.validaNome(gets.chomp)
			contato.nome=(nome)
		when 2
			puts("\n\nDigite o novo endereco:")
			endereco = Validacao.validaEndereco(gets.chomp)
			contato.endereco=(endereco)
		end

		if escolha > 2 && escolha < contato.telefones.size+3
			puts("\n\nDigite o novo numero:")
			telefone = Validacao.validaTelefone(gets.chomp)
			contato.telefones[escolha-3].numero = telefone
		end

		if (escolha >=1 && escolha < contato.telefones.size+3)
			dao.editar(contato)
		end

	break if escolha == contato.telefones.size+3
	end
end

#tela de exclusao do contato

def excluir(contato)
	puts("\n\nTem certeza que deseja excluir o contato? S/N: ")
	if Validacao.excluirCase(gets.chomp)
		ContatoDAO.new.excluir(contato.id)
		puts("\nContato Excluido com sucesso!\n")
	end
end

puts("                 _____________________________")
puts("        	/                             \\  ")
puts("  .~q`,         |    WELCOME TO AGENDA PARK!  |")
puts(" {__,  \\        \\_____________________________/ ")
puts("     \\' \\")
puts("      \\  \\")
puts("       \\  \\")
puts("        \\  `._            __.__")
puts("         \\    ~-._  _.==~~     ~~--.._")
puts("          \\        '                  ~-.")
puts("           \\      _-   -_                `.")
puts("            \\    /       }        .-    .  \\")
puts("             `. |      /  }      (       ;  \\")
puts("               `|     /  /       (       :   '\\")
puts("                \\    |  /        |      /       \\")
puts("                 |     /`-.______.\\     |~-.      \\")
puts("                 |   |/           (     |   `.      \\_")
puts("                 |   ||            ~\\   \\      '._    `-.._____..----..___")
puts("                 |   |/             _\\   \\         ~-.__________.-~~~~~~~~~'''")
puts("               .o'___/            .o______}\n\n\n\n\n")


#menu principal do programa

loop do
	puts("--------------------------------\nMenu\n--------------------------------\n1.Adicionar contatos\n2.Listar contatos\n3.Sair")
	puts("\nDigite o numero da acao:")
	escolha = Validacao.numopcoes(gets.to_i, 3)
	case escolha
	when 1
		adicionarContato
	when 2
		listarContatos
	when 3
		puts("\n\n\n\n             _____________________________")
		puts(" |\\/\\/\\/|   /                             \\")
		puts(" |      |   |      BART ESTAVA AQUI!      |")
		puts(" | (o)(o)   \\_   _________________________/  ")
		puts(" c      _)    | /  ")
		puts("  | '___|    <_/")
		puts("  |   /")
		puts("  /____\\")
		puts(" /      \\ \n\n\n\n")

		puts("             _____________________________")
		puts("            /                             \\")
		puts("            |     AGORA NAO ESTA MAIS!    |")
		puts("            \\_____________________________/ \n\n\n\n\n\n")

		puts("                      ATE MAIS!           \n\n\n\n")
		break

	end


end