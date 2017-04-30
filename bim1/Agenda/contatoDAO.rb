class ContatoDAO

def salvar(contato)
	if(File.exists?("contatos.csv") == false)
		File.new("contatos.csv", "w+")
	end
	arq = File.open("contatos.csv", "a+")
	
	contato.id=(num_contatos + 1)
	arq.puts(toLine(contato))
	arq.close
end

def listar
	result = []
	if File.exists?("contatos.csv")
		result = []
		linhas = File.readlines("contatos.csv")
		i = 0
		while i < linhas.size
			itens = linhas[i].split(";")
			result[result.size] = Contato.new(itens[1], itens[2], itens[3], itens[0])
			i = i + 1
		end
	end
	result
end

def listarbyName(nome)
	contatos = listar
	final = []
	c = nil
	for c in contatos

		if(c.nome.downcase.include? nome)
			final[final.size] = c
		end
	end
	final
end

def editar(contato)
	contatos = listar
	File.delete("contatos.csv")
	for c in contatos
		if c.id == contato.id
			salvar(contato)
		else
			salvar(c)
		end
	end
end

def excluir(id)
	contatos = listar
	File.delete("contatos.csv")
	for c in contatos
		if c.id != id
			salvar(c)
		end
	end
end

def toLine(contato)
	(contato.id.to_s + ";" + contato.nome.to_s + ";" + contato.telefone.to_s + ";" + contato.endereco.to_s)
end

def num_contatos
	lista = listar
	if lista.size == 0
		0
	else
		(lista[lista.size-1].id.to_i + 1)
	end
end

def toHTML(contatos)
	if File.exists?("lista.html")
		File.delete("lista.html")
	end
	arq = File.new("lista.html", "w+")
	arq.puts("<!DOCTYPE html><html><head><title>Lista de Contatos</title><style type='text/css'>" +
			 "table, th, tr, td{border: 1px solid;border-collapse: collapse;}</style></head><body>" +
			 "<table><tr><th>Nome</th><th>Telefone</th><th>Endereco</th></tr>")

	for c in contatos
		arq.puts("<tr><td>#{c.nome}</td><td>#{c.telefone}</td><td>#{c.endereco}</td></tr>")
	end

	arq.puts("</table></body></html>")
	arq.close
end

def existeNome(nome)
	contatos = listar
	retorna = false
	for c in contatos
		if nome == c.nome
			retorna = true
			break
		end
	end
	retorna
end

def existeTel(tel)
	contatos = listar
	retorna = false
	for c in contatos
		if tel == c.telefone
			retorna = true
			break
		end
	end
	retorna
end
end