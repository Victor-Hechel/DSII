require 'pg'

class PresenteDAO

	def save(presente)
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		res = con.exec_params("INSERT INTO presentes VALUES(DEFAULT, $1, $2) RETURNING id;", [presente.nome, presente.preco]);

		res[0]["id"]
	end

	def findAll()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		res = con.exec("SELECT * FROM presentes");

		presentes = []

		res.each do |value|
			presente = Presente.new
			presente.id = value['id']
			presente.nome = value['nome']
			presente.preco = value['preco']
			presentes.push(presente)
		end

		presentes
	end

	def delete(id)
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		con.exec_params("DELETE FROM presentes WHERE id = $1", [id])

	end

	def maior()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		rs = con.exec("SELECT MAX(preco) AS maior FROM presentes;")

		rs[0]['maior']
	end

	def menor()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		rs = con.exec("SELECT MIN(preco) AS menor FROM presentes;")

		rs[0]['menor']
	end

	def media()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		rs = con.exec("SELECT AVG(preco) AS media FROM presentes;")

		rs[0]['media']
		
	end

	def moda()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		rs = con.exec("SELECT preco, COUNT(preco) AS num_vezes FROM presentes GROUP BY preco ORDER BY num_vezes DESC LIMIT 1;")

		rs[0]['preco']
	end

	def ultimos()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		res = con.exec("SELECT nome FROM presentes ORDER BY id DESC LIMIT 3;");

		retorno = ""

		res.each do |value|
			retorno = retorno + ";" + value['nome']
		end

		retorno
	end

	def empty()
		con = PG.connect :dbname => 'lista', :user => 'postgres', :host => 'localhost'

		res = con.exec("SELECT COUNT(*) AS vezes FROM presentes")

		if res[0]['vezes'].to_i == 0
			return true
		else
			return false
		end
	end
end