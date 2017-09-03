require 'sinatra'
require 'erb'

require_relative 'models.rb'

get '/'  do
	erb :index
end

get '/produtos' do
	@produtos = Produto.all
	erb :produtos
end

get '/adicionarProduto' do
	erb :adicionarProduto
end

post '/adicionarProduto' do
	produto = Produto.new
	produto.nome = params["produto"]
	produto.preco = params["preco"]
	produto.save
	redirect '/produtos'
end

get '/excluirProduto/:id' do
	produto = Produto.get(params["id"].to_i)
	produto.destroy
	redirect '/produtos'
end

get '/editarProduto/:id' do
	@produto = Produto.get(params["id"].to_i)
	erb :editarProduto
end

post '/editarProduto' do
	produto = Produto.get(params["id"].to_i)
	produto.update(:nome => params["produto"].to_s, :preco => params["preco"])
	redirect '/produtos'
end

get '/clientes' do
	@clientes = Cliente.all
	erb :clientes
end

get '/adicionarCliente' do
	erb :adicionarCliente
end

post '/adicionarCliente' do
	cliente = Cliente.new

	cliente.nome = params["nome"]
	cliente.cpf = params["cpf"]

	cliente.save

	redirect '/clientes'
end

get '/excluirCliente/:id' do
	cliente = Cliente.get(params['id'].to_i)
	cliente.destroy

	redirect '/clientes'
end

get '/editarCliente/:id' do
	@cliente = Cliente.get(params['id'].to_i)

	erb :editarCliente
end

post '/editarCliente' do
	cliente = Cliente.get(params['id'].to_i)

	cliente.update(:nome => params['nome'].to_s, :cpf => params['cpf'].to_i)

	redirect '/clientes'
end

get '/garcons' do
	@garcons = Garcom.all
	erb :garcons
end

get '/adicionarGarcom' do
	erb :adicionarGarcom
end

post '/adicionarGarcom' do
	garcom = Garcom.new
	garcom.nome = params["nome"]
	garcom.cpf = params["cpf"]
	garcom.dataIngresso = Time.new.to_s

	garcom.save

	redirect '/garcons'

end

get '/excluirGarcom/:id' do
	garcom = Garcom.get(params['id'].to_i)
	garcom.destroy

	redirect '/garcons'
end

get '/editarGarcom/:id' do
	@garcom = Garcom.get(params['id'].to_i)

	erb :editarGarcom
end

post '/editarGarcom' do
	garcom = Garcom.get(params["id"].to_i)
	garcom.update(:nome => params["nome"], :cpf => params["cpf"])

	redirect '/garcons'
end

get '/desligarGarcom/:id' do
	garcom = Garcom.get(params["id"].to_i)
	garcom.update(:dataDesligamento => Time.new.to_s)

	redirect '/garcons'
end

get '/comandas' do
	@comandas = Comanda.all

	erb :comandas
end

get '/adicionarComanda' do
	@clientes = Cliente.all
	@garcons = Garcom.all(:dataDesligamento => nil)

	erb :adicionarComanda
end

post '/adicionarComanda' do
	comanda = Comanda.new
	comanda.abertura = DateTime.now
	comanda.cliente = Cliente.get(params["cliente"].to_i)
	comanda.garcom = Garcom.get(params["garcom"].to_i)

	comanda.save

	redirect '/comandas'

end

get '/excluirComanda/:id' do
	itens = Item.all(:comanda_id => params["id"].to_i)
	itens.each do |item|
		item.destroy
	end
	comanda = Comanda.get(params["id"].to_i)
	comanda.destroy

	redirect '/comandas'
end

get '/editarComanda/:id' do
	@comanda = Comanda.get(params["id"].to_i)
	@clientes = Cliente.all
	@garcons = Garcom.all(:dataDesligamento => nil)

	erb :editarComanda
end

post '/editarComanda' do
	comanda = Comanda.get(params["id"].to_i)

	comanda.update(:cliente => Cliente.get(params["cliente"].to_i), 
				   :garcom => Garcom.get(params["garcom"].to_i))

	redirect '/comandas'
end

get '/fecharComanda/:id' do
	comanda = Comanda.get(params["id"].to_i)
	comanda.update(:encerramento => DateTime.now)

	redirect '/comandas'
end

get '/comprar/:id' do
	@id = params["id"].to_i
	@produtos = Produto.all

	erb :comprar
end

post '/comprar' do
	#comanda = Comanda.get(params['id'].to_i)
	item = Item.first(:comanda_id => params['id'].to_i, :produto_id => params["produto"].to_i)

	if item != nil
		item.update(:quantidade => item.quantidade + 1)
	else
		item = Item.new
		item.comanda = Comanda.get(params['id'].to_i)
		item.produto = Produto.get(params["produto"].to_i)
		item.quantidade = 1
		item.save
	end


	#comanda.produtos.push(Produto.get(params["produto"].to_i))

	#comanda.save

	redirect '/comandas'
end

get '/removerItem/:idComanda/:idProduto' do
	item = Item.first(:comanda_id => params['idComanda'].to_i, :produto_id => params["idProduto"].to_i)

	if item.quantidade == 1
		item.destroy
	else
		item.update(:quantidade => item.quantidade - 1)
	end

	redirect '/comandas'
end

get '/garconsToppers' do
	records = repository(:default).adapter.select("SELECT gar.id, COUNT(com.garcom_id) FROM comandas com JOIN "+
												  "garcoms gar ON (com.garcom_id = gar.id) GROUP BY gar.id " +
												  "ORDER BY COUNT(com.garcom_id) DESC LIMIT 3;")

	@garcons = []
	@counts = []

	records.each do |row|
		garcom = Garcom.get(row["id"].to_i)
		@garcons.push(garcom)
		@counts.push(row["count"].to_i)
	end

	erb :garcons
end

get '/clientesToppers' do
	records = repository(:default).adapter.select("SELECT cli.id, COUNT(com.cliente_id) FROM comandas com "+
												  "JOIN clientes cli ON (com.cliente_id = cli.id) "+ 
												  "GROUP BY cli.id ORDER BY COUNT(com.cliente_id) DESC;")

	@clientes = []
	@counts = []

	records.each do |row|
		@clientes.push(Cliente.get(row["id"].to_i))
		@counts.push(row["count"].to_i)
	end

	erb :clientes
end

get '/comandasAbertas' do
	@comandas = Comanda.all(:encerramento => nil)

	erb :comandas
end