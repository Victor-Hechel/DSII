require 'sinatra'
require 'erb'

require_relative 'models.rb'


get '/' do
	erb :index
end

get '/adicionarPersonagem' do
	@habilidades = Habilidade.all
	@equipes = Equipe.all
	erb :adicionarPersonagem
end

post '/adicionarPersonagem' do
	if params['tipo'] == 'heroi'
		heroi = Heroi.new
		heroi.nome = params["nome"]
		heroi.nome_verdadeiro = params['nome_verdadeiro']
		heroi.habilidades << Habilidade.get(params['habilidade'].to_i)
		heroi.equipe = Equipe.get(params['equipe'].to_i)
		heroi.fas = params['fas'].to_i

		heroi.save
	else
		vilao = Vilao.new
		vilao.nome = params["nome"]
		vilao.nome_verdadeiro = params['nome_verdadeiro']
		vilao.habilidades << Habilidade.get(params['habilidade'].to_i)
		vilao.equipe = Equipe.get(params['equipe'].to_i)
		vilao.capangas = params['capangas'].to_i

		vilao.save
	end

	redirect '/'
end

get '/adicionarHabilidade' do
	erb :adicionarHabilidade
end

post '/adicionarHabilidade' do
	habilidade = Habilidade.new
	habilidade.nome = params['nome'].to_s
	habilidade.impacto = params['nivel'].to_s
	habilidade.descricao = params['descricao'].to_s

	habilidade.save

	redirect '/'
end

get '/adicionarEquipe' do
	erb :adicionarEquipe
end

post '/adicionarEquipe' do
	equipe = Equipe.new
	equipe.nome = params['nome'].to_s

	equipe.save

	redirect '/'
end

get '/listarPersonagens' do
	@personagens = Personagem.all

	erb :listarPersonagens
end

get '/listarHabilidades' do
	@habilidades = Habilidade.all

	erb :listarHabilidades
end

get '/listarEquipes' do
	@equipes = Equipe.all

	erb :listarEquipes
end

get '/excluirEquipe/:id' do
	equipe = Equipe.get(params["id"].to_i)
	equipe.personagems.each do |personagem|
		personagem.update(:habilidades => [])
		personagem.destroy
	end
	equipe.destroy

	redirect '/'
end

get '/excluirHabilidade/:id' do

	habilidade = Habilidade.get(params["id"].to_i)
	habilidade.destroy
	redirect '/'
end

get '/excluirPersonagem/:id' do
	personagem = Personagem.get(params['id'].to_i)
	personagem.update(:habilidades => [])
	personagem.destroy

	redirect '/'
end

get '/editarPersonagem/:id' do
	@personagem = Personagem.get(params['id'].to_i)

	if @personagem.type.to_s == "Heroi"
		@heroi = Heroi.get(params['id'].to_i)

	else
		@vilao = Vilao.get(params['id'].to_i)
	end

	erb :editarPersonagem
end

post '/editarPersonagem' do

	personagem = Personagem.get(params["id"].to_i)
	habilidades = personagem.habilidades
	equipe = personagem.equipe

	personagem.update(:habilidades => [])
	personagem.destroy

	if params['heroi'].to_s == "heroi"
		heroi = Heroi.new
		heroi.nome = params["nome"]
		heroi.nome_verdadeiro = params["nome_verdadeiro"]
		heroi.habilidades = habilidades
		heroi.fas = params["fas"]
		heroi.equipe = equipe

		heroi.save
		
	else
		vilao = Vilao.new
		vilao.nome = params["nome"]
		vilao.nome_verdadeiro = params["nome_verdadeiro"]
		vilao.habilidades = habilidades
		vilao.capangas = params["capangas"]
		vilao.equipe = equipe

		vilao.save
		
	end

	redirect '/'
end

get '/editarHabilidade/:id' do
	@habilidade = Habilidade.get(params['id'].to_i)

	erb :editarHabilidade
end

post '/editarHabilidade' do
	habilidade = Habilidade.get(params['id'].to_i)

	habilidade.update(:nome => params["nome"],
					  :impacto => params["nivel"],
					  :descricao => params["descricao"])

	redirect '/'
end

get '/incorporarHabilidade' do
	@personagens = Personagem.all
	@habilidades = Habilidade.all

	erb :incorporarHabilidade
end

post '/incorporarHabilidade' do
	personagem = Personagem.get(params['personagem'].to_i)
	habilidade = Habilidade.get(params['habilidade'].to_i)
	personagem.habilidades << habilidade

	personagem.save

	redirect '/'
end

get '/editarEquipe/:id' do
	@equipe = Equipe.get(params["id"].to_i)

	erb :editarEquipe
end

post '/editarEquipe' do
	equipe = Equipe.get(params["id"].to_i)
	equipe.update(:nome => params["nome"].to_s)

	redirect '/'
end

get '/removerHabilidade/:idPersonagem/:idHabilidade' do
	personagem = Personagem.get(params["idPersonagem"].to_i)
	habilidades = []
	personagem.habilidades.each do |habilidade|
		if habilidade.id != params["idHabilidade"].to_i
			habilidades.push(habilidade)		
		end
	end
	personagem.update(:habilidades => habilidades)
	personagem.save

	redirect '/'
end