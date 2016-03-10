require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |c|
  options = ['--color']
  options += ["--format", "documentation"]
  c.rspec_opts = options
end

desc "Generate Lexer"
task :lexer do
  `rex objective_plox_lex.rex -o lexer.rb`
end

desc "Generate Parser"
task :parser do
  `racc -v objective_plox_bison.y -o parser.rb`
end

desc "Generate Lexer and Parser"
task :generate => [:lexer, :parser]
