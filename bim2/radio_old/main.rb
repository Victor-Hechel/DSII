#encoding: utf-8

require 'sinatra'
require 'erb'

#modelos
require_relative 'models/comunicador.rb'
require_relative 'models/programa.rb'

#DAOs
require_relative 'DAO/comunicadorDAO.rb'
require_relative 'DAO/programaDAO.rb'
require_relative 'DAO/adminDAO.rb'

enable :sessions

before '/protected/*' do
	if session[:logado] != "1"
		redirect '/loga'
	end
end

get '/' do
	if session[:logado] == "1"
		erb :home, :layout => :layout_admin
	else
		erb :home
	end
end

get '/home' do
	if session[:logado] == "1"
		erb :home, :layout => :layout_admin
	else
		erb :home
	end
end

get '/protected/comunicador' do
	erb :comunicador, :layout => :layout_admin
end

post '/protected/cadastrarComunicador' do
	comunicador = Comunicador.new
	comunicador.nome = params['nome']
	dao = ComunicadorDAO.new
	if params['arquivo'] != nil
		comunicador.extensao = File.extname(params['arquivo'][:filename])
	end
	id = dao.save(comunicador)
	comunicador.id = id
	if (comunicador.extensao != nil)
		File.open('./public/uploads/comunicadores/' + comunicador.formaImagem(), "w") do |f|
			f.write(params['arquivo'][:tempfile].read)
		end
	end

	redirect '/home'
end

get '/protected/programa' do
	dao = ComunicadorDAO.new
	@comunicadores = dao.listar()
	erb :programa, :layout => :layout_admin
end

post '/protected/cadastrarPrograma' do
	programa = Programa.new
	programa.nome = params['nome']
	programa.inicio = params['inicio']
	programa.fim = params['fim']
	programa.dia = params['dia']
	programa.id_comunicador = params['comunicador'].to_i
	if params['arquivo'] != nil
		programa.extensao = File.extname(params['arquivo'][:filename])
	end
	dao = ProgramaDAO.new
	id = dao.save(programa)
	programa.id = id
	if programa.extensao != nil
		File.open('./public/uploads/programas/' + programa.formaImagem(), "w") do |f|
			f.write(params['arquivo'][:tempfile].read)
		end
	end
	redirect '/home'
end

get '/programacao' do
	dao = ProgramaDAO.new
	@segunda = dao.listarPorDia("Segunda")
	@terca = dao.listarPorDia("Terca")
	@quarta = dao.listarPorDia("Quarta")
	@quinta = dao.listarPorDia("Quinta")
	@sexta = dao.listarPorDia("Sexta")
	@sabado = dao.listarPorDia("Sabado")
	@domingo = dao.listarPorDia("Domingo")
	if session[:logado] == "1"
		erb :programacao, :layout => :layout_admin
	else
		erb :programacao
	end
end

get '/programa/:id' do
	dao = ProgramaDAO.new
	@programa = dao.getPrograma(params["id"].to_i)
	@comunicador = ComunicadorDAO.new.getComunicador(@programa.id_comunicador)
	if session[:logado] == "1"
		erb :programaUniq_admin, :layout => :layout_admin
	else
		erb :programaUniq
	end
end

get '/protected/deletarPrograma/:id' do
	dao = ProgramaDAO.new
	programa = dao.getPrograma(params["id"].to_i)
	File.delete('./public/uploads/programas/'+programa.formaImagem()) if File.exist?('./public/uploads/programas/'+programa.formaImagem())
	dao.deletar(params["id"].to_i)
	erb :home, :layout => :layout_admin
end

get '/protected/editarPrograma/:id' do
	dao = ProgramaDAO.new
	@programa = dao.getPrograma(params["id"].to_i)
	@comunicadores = ComunicadorDAO.new.listar()
	erb :editarPrograma, :layout => :layout_admin
end

post '/protected/editarProgramaPost/:id' do
	dao = ProgramaDAO.new
	programa = Programa.new
	programa.id = params["id"]
	programa.nome = params['nome']
	programa.inicio = params['inicio']
	programa.fim = params['fim']
	programa.dia = params['dia']
	programa.id_comunicador = params['comunicador'].to_i
	if params['foto'] == nil
		programa.extensao = params['extensao']
	else
		programa.extensao = params['extensao']
		puts "------------"
		puts programa.extensao
		File.delete('./public/uploads/programas/'+programa.formaImagem()) if File.exist?('./public/uploads/programas/'+programa.formaImagem())
		programa.extensao = File.extname(params['foto'][:filename])
		File.open('./public/uploads/programas/' + programa.formaImagem(), "w") do |f|
			f.write(params['foto'][:tempfile].read)
		end
	end
	dao = ProgramaDAO.new
	dao.update(programa)
	redirect '/programa/' + programa.id
end


get '/comunicadores' do
	dao = ComunicadorDAO.new
	@comunicadores = dao.listar()
	if session[:logado] == "1"
		erb :comunicadores_admin, :layout => :layout_admin
	else
		erb :comunicadores
	end
end

get '/protected/excluirComunicador/:id' do
	dao = ComunicadorDAO.new
	comunicador = dao.getComunicador(params["id"].to_i)
	dao.deletar(params["id"].to_i)
	if comunicador.extensao != nil
		File.delete('./public/uploads/comunicadores/'+comunicador.formaImagem()) if File.exist?('./public/uploads/comunicadores/'+comunicador.formaImagem())
	end
	erb :home, :layout => :layout_admin
end

get '/protected/editarComunicador/:id' do
	dao = ComunicadorDAO.new
	@comunicador = dao.getComunicador(params["id"].to_i)

	erb :comunicadorEditar, :layout => :layout_admin
end

post '/protected/editarComunicadorPost/:id' do
	dao = ComunicadorDAO.new
	comunicador = Comunicador.new
	comunicador.id = params["id"].to_i
	comunicador.nome = params["nome"]
	if params['foto'] == nil
		comunicador.extensao = params['extensao']
	else
		File.delete('./public/uploads/comunicadores/'+comunicador.id.to_s + params['extensao']) if File.exist?('./public/uploads/comunicadores/'+comunicador.id.to_s + params['extensao'])
		comunicador.extensao = File.extname(params['foto'][:filename])
		File.open('./public/uploads/comunicadores/' + comunicador.formaImagem(), "w") do |f|
			f.write(params['foto'][:tempfile].read)
		end
	end
	dao.update(comunicador)
	redirect '/comunicadores'
end

get '/loga' do
	erb :login
end

post '/logar' do
	login = params["login"].to_s
	senha = params["senha"].to_s
	if(AdminDAO.new.existe(login, senha) != 0)
		session[:logado] = "1"
		redirect "/"
	else
		redirect "/loga"
	end
end

get '/logout' do
	session[:logado] = "0"
	erb :home
end

get '/teste' do
	erb :layout
end