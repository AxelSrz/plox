require './parser.rb'

prueba = ObjectivePlox.new
puts "Ingrese el nombre del archivo a parsear junto con su extension: "
STDOUT.flush
nombre = gets.chomp
prueba.parse(nombre)