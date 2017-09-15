require "tk"

require 'tkextlib/bwidget'

require './models.rb'

$root = TkRoot.new
$root.title = "Windows"
$root.width = 400
$root.height = 400

def logar(input1, input2)
	login = input1.get
	senha = input2.get

	usuarios = Usuario.all(:login => login, :senha => senha)	

	if usuarios.length != 0
		limparTela
		if usuarios[0].admin
			gerarTelaAdmin
		else
			$usuario = usuarios[0]
			gerarTelaUser
		end
	end
end

def limparTela
	for ele in $root.winfo_children()
  		ele.destroy()
  	end
end

def gerarTelaUser

	$usuario = Usuario.get($usuario.id)

	list = TkListbox.new($root) do
		setgrid 1
		selectmode 'single'
		pack('fill' => 'x')
	end

	i = 0

	for item in $usuario.anotacaos
		texto = item.titulo + " | " + item.descricao + " | " + item.data + " | " + item.hora
	    list.insert(i, texto)
	    i = i + 1
	end

	button1 = TkButton.new($root) do
		command (proc {editarUsuarioTela($usuario)})
		text 'Editar Usuário'
	end

	button2 = TkButton.new($root) do
		command (proc {excluirAnotacao(list)})
		text 'Excluir Anotação'
	end

	button3 = TkButton.new($root) do
		command (proc {editarAnotacaoTela(list)})
		text 'Editar Anotação'
	end

	button4 = TkButton.new($root) do
		command (proc {adicionarAnotacaoTela})
		text 'Adicionar Anotação'
	end

	list.place('height' => 200, 'width' => 300)
	button1.place('height' => 20, 'width' => 300, 'y' => 200)
	button2.place('height' => 20, 'width' => 300, 'y' => 220)
	button3.place('height' => 20, 'width' => 300, 'y' => 240)
	button4.place('height' => 20, 'width' => 300, 'y' => 260)

end

def adicionarAnotacaoTela
	limparTela

	label1 = TkLabel.new($root) do
		text "Título: "
	end

	label2 = TkLabel.new($root) do
		text "Descrição: "
	end

	label3 = TkLabel.new($root) do
		text "Data: "
	end

	label4 = TkLabel.new($root) do
		text "Hora: "
	end

	entry1 = TkEntry.new($root)
	entry2 = TkEntry.new($root)
	entry3 = TkEntry.new($root)
	entry4 = TkEntry.new($root)

	button = TkButton.new($root) do
		command (proc{adicionarAnotacao(entry1, entry2, entry3, entry4)})
		text 'Adicionar'
	end

	label1.place('height' => 20, 'width' => 50, 'y' => 0)
	label2.place('height' => 20, 'width' => 50, 'y' => 20)
	label3.place('height' => 20, 'width' => 50, 'y' => 40)
	label4.place('height' => 20, 'width' => 50, 'y' => 60)


	entry1.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 0)
	entry2.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 20)
	entry3.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 40)
	entry4.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 60)

	button.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 80)


end

def adicionarAnotacao(entry1, entry2, entry3, entry4)
	anotacao = Anotacao.new
	anotacao.titulo = entry1.get
	anotacao.descricao = entry2.get
	anotacao.data = entry3.get
	anotacao.hora = entry4.get

	anotacao.usuario = $usuario

	anotacao.save

	gerarTelaUser
end


def excluirAnotacao(list)
	nome = list.get(list.curselection()).split(' | ').first
	anotacao = Anotacao.all(:titulo => nome)[0]
	anotacao.destroy
	limparTela
	gerarTelaUser
end

def editarAnotacaoTela(list)
	nome = list.get(list.curselection()).split(' | ').first
	anotacao = Anotacao.all(:titulo => nome)[0]

	limparTela

	label1 = TkLabel.new($root) do
		text "Título: "
	end

	label2 = TkLabel.new($root) do
		text "Descrição: "
	end

	label3 = TkLabel.new($root) do
		text "Data: "
	end

	label4 = TkLabel.new($root) do
		text "Hora: "
	end

	entry1 = TkEntry.new($root)
	entry2 = TkEntry.new($root)
	entry3 = TkEntry.new($root)
	entry4 = TkEntry.new($root)

	entry1.set(anotacao.titulo)
	entry2.set(anotacao.descricao)
	entry3.set(anotacao.data)
	entry4.set(anotacao.hora)

	button = TkButton.new($root) do
		command (proc{editarAnotacao(entry1, entry2, entry3, entry4, anotacao)})
		text 'Editar'
	end

	label1.place('height' => 20, 'width' => 50, 'y' => 0)
	label2.place('height' => 20, 'width' => 50, 'y' => 20)
	label3.place('height' => 20, 'width' => 50, 'y' => 40)
	label4.place('height' => 20, 'width' => 50, 'y' => 60)


	entry1.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 0)
	entry2.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 20)
	entry3.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 40)
	entry4.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 60)

	button.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 80)

end


def editarAnotacao(entry1, entry2, entry3, entry4, anotacao)
	anotacao.update(:titulo => entry1.get, :descricao => entry2.get, :data => entry3.get, :hora => entry4.get)
	
	gerarTelaUser
end

def gerarTelaAdmin
	
	list = TkListbox.new($root) do
		setgrid 1
		selectmode 'single'
		pack('fill' => 'x')
	end

	i = 0

	for item in Usuario.all
	    list.insert(i, item.nome)
	    i = i + 1
	end

	button1 = TkButton.new($root) do
		command (proc {excluirUser(list)})
		text 'Excluir'
	end

	button2 = TkButton.new($root) do
		command (proc {preEditarUsuarioTela(list)})
		text 'Editar'
	end

	button3 = TkButton.new($root) do
		command (proc {adicionarUsuarioTela})
		text 'Adicionar Usuario'
	end

	list.place('height' => 200, 'width' => 200)
	button1.place('height' => 20, 'width' => 200, 'y' => 200)
	button2.place('height' => 20, 'width' => 200, 'y' => 220)
	button3.place('height' => 20, 'width' => 200, 'y' => 240)

end

def adicionarUsuario(entry1, entry2, entry3, combobox)

	usuario = Usuario.new

	usuario.nome = entry1.get
	usuario.login = entry2.get
	usuario.senha = entry3.get
	if combobox.text == 'Admin'
		usuario.admin = true
	else
		usuario.admin = false
	end
	usuario.save

	limparTela

	gerarTelaAdmin

end

def excluirUser(list)
	nome = list.get(list.curselection())
	usuario = Usuario.all(:nome => nome)[0]
	usuario.destroy
	limparTela
	gerarTelaAdmin
end

def adicionarUsuarioTela
	limparTela

	label1 = TkLabel.new($root) do
		text 'Nome: '
	end

	label2 = TkLabel.new($root) do
		text 'Login: '
	end

	label3 = TkLabel.new($root) do
		text 'Senha:'
	end

	combobox = Tk::BWidget::ComboBox.new($root)
	combobox.values = ['Admin', 'Usuario']

	entry1 = TkEntry.new($root)
	entry2 = TkEntry.new($root)
	entry3 = TkEntry.new($root) do
		show '*'
	end

	button = TkButton.new($root) do
		command (proc{adicionarUsuario(entry1, entry2, entry3, combobox)})
		text 'Cadastrar'
	end

	label1.place('height' => 20, 'width' => 50, 'y' => 0)
	label2.place('height' => 20, 'width' => 50, 'y' => 20)
	label3.place('height' => 20, 'width' => 50, 'y' => 40)

	entry1.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 0)
	entry2.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 20)
	entry3.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 40)

	combobox.place('height' => 20, 'width' => 200, 'y' => 60, 'x' => 60)

	button.place('height' => 20, 'width' => 200, 'y' => 80, 'x' => 60)
end

def preEditarUsuarioTela(list)
	nome = list.get(list.curselection[0])

	usuario = Usuario.all(:nome => nome)[0]

	editarUsuarioTela(usuario)
end

def editarUsuarioTela(usuario)

	limparTela

	label1 = TkLabel.new($root) do
		text 'Nome: '
	end

	label2 = TkLabel.new($root) do
		text 'Login: '
	end

	label3 = TkLabel.new($root) do
		text 'Senha:'
	end

	combobox = Tk::BWidget::ComboBox.new($root)
	combobox.values = ['Admin', 'Usuario']

	if $usuario == nil

		if usuario.admin
			combobox.text = "Admin"
		else
			combobox.text = "Usuario"		
		end

		combobox.place('height' => 20, 'width' => 200, 'y' => 60, 'x' => 60)
	end

	

	entry1 = TkEntry.new($root)
	entry2 = TkEntry.new($root)
	entry3 = TkEntry.new($root) do
		show '*'
	end

	button = TkButton.new($root) do
		command (proc{editarUsuario(entry1, entry2, entry3, combobox, usuario.id)})
		text 'Cadastrar'
	end

	entry1.set(usuario.nome)
	entry2.set(usuario.login)
	entry3.set(usuario.senha)
	

	label1.place('height' => 20, 'width' => 50, 'y' => 0)
	label2.place('height' => 20, 'width' => 50, 'y' => 20)
	label3.place('height' => 20, 'width' => 50, 'y' => 40)

	entry1.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 0)
	entry2.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 20)
	entry3.place('height' => 20, 'width' => 200, 'x' => 60, 'y' => 40)


	button.place('height' => 20, 'width' => 200, 'y' => 80, 'x' => 60)
end

def editarUsuario(entry1, entry2, entry3, combobox, id)
	usuario = Usuario.get(id)

	admin = false

	if combobox.text == "Admin"
		admin = true
	end

	if $usuario == nil
		usuario.update(:nome => entry1.get, :login => entry2.get, :senha => entry3.get, :admin => admin)
	else
		usuario.update(:nome => entry1.get, :login => entry2.get, :senha => entry3.get)
	end

	

	limparTela

	if $usuario == nil
		gerarTelaAdmin
	else
		gerarTelaUser
	end
end

def criaLogin

	label1 = TkLabel.new($root) do
		text 'Login:'
	end

	label2 = TkLabel.new($root) do
		text 'Senha:'
	end

	input1 = TkEntry.new($root)

	input2 = TkEntry.new($root) do
		show '*'
	end

	button = TkButton.new($root) do
		command (proc {logar(input1, input2)})
		text 'Logar'
	end

	label1.place('height' => 25, 'width' => 50, 'y' => 10)
	label2.place('height' => 25, 'width' => 50, 'y' => 35)
	input1.place('height' => 25, 'width' => 200, 'y' => 10, 'x' => 50)
	input2.place('height' => 25, 'width' => 200, 'y' => 35, 'x' => 50)
	button.place('height' => 25, 'width' => 200, 'y' => 60, 'x' => 50)
end

criaLogin



Tk.mainloop