require_relative "DAO.rb"

class ProgramaDAO

	def save(programa)
		con = DAO.new.getConnection()
		res = con.exec("INSERT INTO programas(nome, duracao, inicio, fim, dia, id_comunicador, formato)
				  VALUES ($1, (($2::TIME) - ($3::TIME)), $3, $2, $4, $5, $6) RETURNING id;", 
				  [programa.nome, programa.fim, programa.inicio,
				   programa.dia, programa.id_comunicador.to_i, programa.extensao.to_s])
		res[0]['id']
	end

	def listarPorDia(dia)
		con = DAO.new.getConnection()
		rs = con.exec_params("SELECT * FROM programas
							  WHERE dia = $1 ORDER BY inicio", [dia])

		resultados = []

		rs.each do |value|
			programa = Programa.new
			programa.id = value["id"]
			programa.nome = value["nome"]
			programa.duracao = value["duracao"]
			programa.inicio = value["inicio"]
			programa.fim = value["fim"]
			programa.id_comunicador = value["id_comunicador"]
			programa.dia = dia
			programa.extensao = value["formato"]
			resultados.push(programa)
		end
		con.close()
		resultados
	end

	def getPrograma(id)
		con = DAO.new.getConnection()
		rs = con.exec_params("SELECT * FROM programas WHERE id = $1", [id.to_i])

		programa = Programa.new

		rs.each do |value|
			programa.id = id
			programa.nome = value["nome"]
			programa.duracao = value["duracao"]
			programa.inicio = value["inicio"]
			programa.fim = value["fim"]
			programa.id_comunicador = value["id_comunicador"]
			programa.dia = value["dia"]
			programa.extensao = value["formato"]
		end
		con.close()
		programa
	end

	def deletar(id)
		con = DAO.new.getConnection()
		con.exec_params("DELETE FROM programas WHERE id = $1", [id.to_i])
		con.close()
	end

	def update(programa)
		con = DAO.new.getConnection()
		con.exec_params("UPDATE programas SET nome = $1, duracao = (($3::TIME) - ($2::TIME)), 
							  inicio = $2, fim = $3, dia = $4, id_comunicador = $5, formato = $6 WHERE id = $7",
							  [programa.nome, programa.inicio,
							   programa.fim, programa.dia, programa.id_comunicador.to_i, programa.extensao, programa.id.to_i])
		con.close()	
	end

	def existe(nome)
		con = DAO.new.getConnection()
		res = con.exec_params("SELECT COUNT(id) as num FROM programas WHERE nome = $1",[nome])
		res[0]['num']
	end
end