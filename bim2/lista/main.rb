#encoding: utf-8

require 'sinatra'
require 'erb'

#modelos
require_relative 'models/presente.rb'

#dao
require_relative 'DAO/presenteDAO.rb'

enable :sessions

get '/cadastro' do
	erb :cadastro
end

post '/cadastrar' do
	presente = Presente.new
	presente.nome = params['nome']
	presente.preco = params['preco']

	dao = PresenteDAO.new

	id = dao.save(presente)

	File.open('./public/uploads/' + id, "w") do |f|
		f.write(params['foto'][:tempfile].read)
	end

	session[:maior] = dao.maior()
	session[:menor] = dao.menor()
	session[:media] = dao.media()
	session[:moda] = dao.moda()

	redirect '/lista'
end

get '/lista' do
	dao = PresenteDAO.new
	@presentes = dao.findAll()
	erb :lista
end

get '/' do
	dao = PresenteDAO.new
	@presentes = dao.findAll()
	erb :lista
end

post '/excluir/:id' do
	id = params['id']

	dao = PresenteDAO.new
	dao.delete(id)

	if !dao.empty()
		session[:maior] = dao.maior()
		session[:menor] = dao.menor()
		session[:media] = dao.media()
		session[:moda] = dao.moda()
	end
	

	File.delete('./public/uploads/'+ id)	

	redirect '/lista'
end

get '/estatisticas' do

	dao = PresenteDAO.new

	if !dao.empty()
		@maior = session[:maior]
		@menor = session[:menor]
		@media = session[:media]
		@moda = session[:moda]

		erb :estatisticas
	else
		erb :cadastro
	end

end

get '/ultimos' do
	dao = PresenteDAO.new

	retorno = dao.ultimos()

	retorno
end