require "pg"

class Connection

	def getConnection 
		PG.connect :dbname => 'agenda', :user => 'postgres', :password => 'postgres', :host => 'localhost'
	end

end