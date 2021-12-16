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
			ast = nil

			begin

				# lexing/parsing/semantic
				ast = Rico::Ricola::Parser::parse(tokens)
				program_is_valid = Rico::Ricola::SemanticAnalyzer.new(ast).is_valid()

				if(program_is_valid)

					# forward backward
					Rico::Ricoco::ForwardBackward.new(ast)
				end

				puts ast

			rescue Exception => e
				puts e.message
			end
		end
	end
end

