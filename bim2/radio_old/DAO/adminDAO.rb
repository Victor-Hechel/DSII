require_relative 'DAO.rb'

class AdminDAO

	def existe(login, senha)
		con = DAO.new.getConnection()
		res = con.exec_params("SELECT COUNT(id) AS num FROM admins WHERE login = $1 AND senha = $2;", [login, senha])
		return res[0]["num"].to_i
	end

end