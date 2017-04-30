require_relative "connection.rb"
require "./telefone.rb"
require_relative "contato.rb"

class ContatoDAO

	def salvar(contato)

		con = Connection.new.getConnection()

		rs = con.exec_params("INSERT INTO contatos(nome, endereco) VALUES($1, $2) RETURNING id;", [contato.nome, contato.endereco])

		contato.telefones[0].id_contato = rs[0]['id'].to_s

		addTelefone(contato.telefones[0])

	end

	def addTelefone(telefone)
		con = Connection.new.getConnection()

		rs = con.exec_params("INSERT INTO telefones(numero, id_contato) VALUES($1, $2) RETURNING id_telefone;", [telefone.numero, telefone.id_contato])

		telefone.id = rs[0]['id_telefone']

	end

	def listar
		result = []

		con = Connection.new.getConnection()

		rs = con.exec("SELECT * FROM contatos")
		if (rs.ntuples > 0)
			rs.each do |value|
				contato = Contato.new
				contato.nome = value['nome'].to_s	
				contato.endereco = value['endereco'].to_s
				contato.id = value['id'].to_i
				contato.telefones = listarTelefones(contato.id)
				result.push(contato)
			end
		end
		result
	end

	def listarTelefones(id)
		con = Connection.new.getConnection()

		puts(id)

		rs = con.exec_params("SELECT id_telefone, numero, id_contato FROM telefones WHERE id_contato = $1", [id])

		vetTelefone = []
		if (rs.ntuples > 0)
			rs.each do |r|
				telefone = Telefone.new
				telefone.id = r['id_telefone']
				telefone.numero = r['numero']
				telefone.id_contato = r['id_contato']

				vetTelefone.push(telefone)
			end
		end

		vetTelefone
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

		con = Connection.new.getConnection()

		con.exec_params("UPDATE contatos SET nome = $1, endereco = $2 WHERE id = $3;", [contato.nome, contato.endereco, contato.id])

		for tel in contato.telefones
			con.exec_params("UPDATE telefones SET numero = $1 WHERE id_telefone = $2", [tel.numero, tel.id])
		end

	end

	def excluir(id)
		con = Connection.new.getConnection()

		con.exec_params("DELETE FROM contatos WHERE id = $1", [id])
	end

	def excluirTelefone(id)

		con = Connection.new.getConnection()

		puts("#{id} sidslfdfdiik")

		con.exec_params("DELETE FROM telefones WHERE id_telefone = $1", [id])
		
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
				 "<table><tr><th>Nome</th><th>Endereco</th><th>Telefone</th></tr>")

		for c in contatos
			arq.puts("<tr><td>#{c.nome}</td><td>#{c.endereco}</td>")
			for tel in c.telefones
				arq.puts("<td>#{tel.numero}</td>")
			end
			arq.puts("</tr>")
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

		con = Connection.new.getConnection()

		rs = con.exec("SELECT numero FROM telefones")

		teste = false

		rs.each do |value|
			if value['numero'].to_s == tel
				teste = true
				break
			end
		end

		teste

	end
end