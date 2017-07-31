require 'sinatra'
require 'erb'

require './models.rb'

get '/' do

	#atributo nos parenteses é +- o mesmo que o WHERE

	#SELECT * FROM professores
	@vet1 = Professor.all

	#SELECT * FROM professores WHERE id > 2 AND id < 6 AND nome != 'marcio'
	@vet2 = Professor.all(:id.gt => 2, :id.lt => 6, :nome.not => "marcio")

	#SELECT * FROM professores ORDER BY nome DESC
	@vet3 = Professor.all(:order => [:nome.desc])

	#SELECT nome, apelido FROM professores
	@vet4 = Professor.all(:fields => [:nome, :apelido])

	#SELECT COUNT(*) FROM professores
	@count = Professor.count

	#SELECT * FROM professores WHERE id = 1
	@prof = Professor.get(1)

	erb :index
end

get '/adicionar' do
	erb :adicionar
end

post '/adicionar' do
	professor = Professor.new
	professor.nome = params["nome"]
	professor.apelido = params["apelido"]
	#Faz o INSERT
	professor.save

	redirect '/'
end

get '/excluir/:id' do
	professor = Professor.get(params["id"].to_i)
	#Faz o DELETE
	professor.destroy
	redirect '/'
end

get '/editar/:id' do
	@professor = Professor.get(params["id"])
	erb :editar
end

post '/editar' do
	professor = Professor.get(params["id"])

=begin
	#NÃO FUNCIONA

	professor.nome = params["nome"]
	professor.apelido = params["apelido"]

	professor.update
=end
	
	#Faz o update
	professor.update(:nome => params["nome"], :apelido => params["apelido"])

	redirect '/'
end