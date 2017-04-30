=begin

exercício 01

numeros = gets.chomp.split(" ")

resultado = 0

i = 0

while i < numeros.size
	resultado = resultado + numeros[i].to_i
	i = i + 1
end

puts resultado
=end

=begin

exercício 02

numeros = gets.chomp.split(" ")

i = 0
resultado = numeros[0];

while i < numeros.size
	if resultado < numeros[i]
		resultado = numeros[i];
	end
	i = i + 1
end

puts resultado
=end

=begin
exercício 4
numero = gets.chomp.to_i

i = 2

teste = true

while i < numero
	if numero % i == 0 
		teste = false
	end
	i = i + 1
end

if teste == true
	puts "eh primo"
else
	puts "nao eh primo"
end

=end

=begin

exercício 5

nome1 = gets.chomp
nome2 = gets.chomp

resultado = ""

i = 0

while i < nome1.size
	resultado = resultado + nome1[i] + nome2[i]
	i = i + 1
end

puts resultado

=end

=begin

exercicio 6

vetor1 = gets.chomp.split(" ")
vetor2 = gets.chomp.split(" ")

puts (vetor1.size + vetor2.size)/2
=

escolha = puts.chomp.to_i

rache = {}

while escolha == 1
	nome = puts.chomp
	matricula = puts.chomp.to_i
	rache{nome} = matricula
end

puts rache
=end

system("firefox hello.html")