require_relative 'DAO.rb'

class ComunicadorDAO

	def save(comunicador)
		con = DAO.new.getConnection()
		res = con.exec_params("INSERT INTO comunicadores(nome, formato) VALUES ($1, $2) RETURNING id;", [comunicador.nome, comunicador.extensao])
		res[0]['id']
	end

	def listar()
		con = DAO.new.getConnection()
		rs = con.exec("SELECT * FROM comunicadores")
		resultado = []
		rs.each do |value|
			comunicador = Comunicador.new
			comunicador.id = value['id'].to_i
			comunicador.nome = value['nome'].to_s
			comunicador.extensao = value['formato'].to_s
			resultado.push(comunicador)
		end
		con.close()
		resultado
	end

	def getComunicador(id)
		con = DAO.new.getConnection()
		rs = con.exec_params("SELECT * FROM comunicadores WHERE id = $1", [id.to_i])

		comunicador = Comunicador.new
		rs.each do |value|
			comunicador.id = id
			comunicador.nome = value["nome"]
			comunicador.extensao = value["formato"]
		end

		con.close()
		comunicador
		
	end

	def deletar(id)
		con = DAO.new.getConnection()
		con.exec_params("DELETE FROM comunicadores WHERE id = $1", [id.to_i])
		con.close()
	end

	def update(comunicador)
		con = DAO.new.getConnection()
		con.exec_params("UPDATE comunicadores SET nome = $1, formato = $2 WHERE id = $3", 
						[comunicador.nome, comunicador.extensao, comunicador.id])
		con.close()
		
	end

	def existe(nome)
		con = DAO.new.getConnection()
		res = con.exec_params("SELECT COUNT(id) as num FROM comunicadores WHERE nome = $1",[nome])
		res[0]['num']
	end

end