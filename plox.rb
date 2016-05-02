#!/usr/bin/env ruby
require './parser.rb'
require './maquinaVirtual.rb'

codigoFuente = ObjectivePlox.new
codigoFuente.parse(ARGV[0])
vm = VirtualMachine.new
vm.execution
