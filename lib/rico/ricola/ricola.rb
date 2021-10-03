require_relative './lexer.rb'
require_relative './parser.rb'
require_relative './ast.rb'
require_relative './semantic.rb'
require_relative './forward_backward.rb'

module Rico
	module Ricola

		# Parse a file and return the constructed AST
		# @param fname [String] the name of the file to parse
		# @return [Ricola::Program] The root node of the AST which is a program
		def self.parse_file(fname)
			tokens = Rico::Ricola::Lexer.lex_file(fname)
=begin
			tokens.each do |t|
				puts "#{t.type}#{t.value ? " #{t.value}":''}"
			end
=end
			ast = nil
			begin

				ast = Rico::Ricola::Parser::parse(tokens)
				semantic = SemanticAnalyzer.new(ast)
				ForwardBackward.new(semantic.constraints)
				ast
			rescue Exception => e
				puts e.message
			end
		end
	end
end

