require 'rltk/lexer'

module Rico
	module Ricola

		class Lexer < RLTK::Lexer
			# Skip whitespace
			rule(/\s/)

			# Section declaration
			rule(/BEGIN/) {:BEGIN}
			rule(/END/) {:END}
			rule(/INPUT/) {:INPUT}
			rule(/OUTPUT/) {:OUTPUT}
			rule(/CONSTRAINT/) {:CONSTRAINT}

			# Operand type
			rule(/INTERVAL/) {:INTERVAL}
			rule(/SCALAR/) {:SCALAR}

			# Data type
			rule(/INTEGER/) {:INTEGER}
			rule(/FLOAT/) {:FLOAT}

			# Symbols
			rule(/;/) {:SEMICOLON}
			rule(/:/) {:COLON}
			rule(/,/) {:COMMA}
			rule(/\(/) {:LPAREN}
			rule(/\)/) {:RPAREN}

			# Operator
			rule(/=/)	{ :EQUAL  }
			rule(/</)	{ :LT     }
			rule(/<=/)	{ :LE     }
			rule(/>/)	{ :GT     }
			rule(/>=/)	{ :GE     }
			rule(/\+/)	{ :PLUS   }
			rule(/-/)	{ :SUB	}
			rule(/\*/)	{ :MUL	}
			rule(/\//)	{ :DIV	}
			rule(/\*\*/){ :POW	}

			# Identifier
			rule(/[A-Za-z][A-Za-z0-9]*/) { |t| [:IDENT, t.to_s] }

			# Numeric rules.
			rule(/\d+(\.\d+)?(e-?\e+)?/) { |t| [:NUMBER, t.to_f] }
			#rule(/\d+/)			{ |t| [:NUMBER, t.to_f] }
			#rule(/\.\d+/)		{ |t| [:NUMBER, t.to_f] }
			#rule(/\d+\.\d+/)	{ |t| [:NUMBER, t.to_f] }

			# Comment rules.
			rule(/#/)				{ push_state :comment }
			rule(/\n/, :comment)	{ pop_state }
			rule(/./, :comment)
		end

	end
end
