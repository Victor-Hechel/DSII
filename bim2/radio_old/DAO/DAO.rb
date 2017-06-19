require 'pg'

class DAO

	def getConnection()
		PG.connect :dbname => 'radio', :user => 'postgres', :host => 'localhost'
	end

end