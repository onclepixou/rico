require 'rltk/parser'
require_relative './ast.rb'

module Rico
	module Ricola

		class Parser < RLTK::Parser
			production(:program, 'input_section output_section constraint_section') do |s, o, c|
				Ricola::Program.new(s, o, c)
			end

			production(:input_section, 'BEGIN INPUT .decl_list END INPUT SEMICOLON') { |l| Ricola::InputSection.new(l) }

			production(:output_section, 'BEGIN OUTPUT .decl_list END OUTPUT SEMICOLON') { |l| Ricola::OutputSection.new(l) }

			production(:constraint_section, 'BEGIN CONSTRAINT .constraint_list END CONSTRAINT SEMICOLON') do |l|
				Ricola::ConstraintList.new(l)
			end

			list(:decl_list, :decl)

			production(:decl, '.operand_type .id LPAREN .data_type RPAREN SEMICOLON') do |t, i, d|
				Ricola::Declaration.new(t, i, d)
			end

			production(:operand_type) do
				clause('INTERVAL') { |_| :interval }
				clause('SCALAR')   { |_| :scalar   }
			end

			production(:id, 'IDENT') {|i| i }

			production(:data_type) do
				clause('INTEGER') { |_| :integer }
				clause('FLOAT')   { |_| :float   }
			end

			list(:constraint_list, :constr)

			production(:constr, ".id COLON .equation SEMICOLON") {|i, e| Ricola::Constraint.new(i, e)}

			production(:equation) do
				clause('.expr EQUAL .expr') { |l, r| Ricola::Equal.new(l, r) }
				clause('.expr LT .expr')    { |l, r| Ricola::LowerThan.new(l, r) }
				clause('.expr LE .expr')    { |l, r| Ricola::LowerEqual.new(l, r) }
				clause('.expr GT .expr')    { |l, r| Ricola::GreaterThan.new(l, r) }
				clause('.expr GE .expr')    { |l, r| Ricola::GreaterEqual.new(l, r) }
			end

			production(:expr) do
				clause('term')             { |e| e }
				clause('.expr PLUS .term') { |l, r| Ricola::Add.new(l, r) }
				clause('.expr SUB .term')  { |l, r| Ricola::Sub.new(l, r) }
			end

			production(:term) do
				clause('factor')            { |e| e }
				clause('.term MUL .factor') { |l, r| Ricola::Mul.new(l, r) }
				clause('.term DIV .factor') { |l, r| Ricola::Div.new(l, r) }
			end

			production(:factor) do
				clause('paren')              { |e| e }
				clause('.paren POW .factor') { |l, r| Ricola::Pow.new(l, r) }
			end

			production(:paren) do
				clause('prim')                { |e| e }
				clause('LPAREN .expr RPAREN') { |e| e }
			end

			production(:prim) do
				clause('SUB .NUMBER')  { |v| Ricola::Number.new(-v) }
				clause('ADD .NUMBER')  { |v| Ricola::Number.new(v)  }
				clause('NUMBER')       { |v| Ricola::Number.new(v)  }
				clause('.IDENT LPAREN .expr_list RPAREN') { |i, e| Ricola::FunctionCall.new(i, e) }
				clause('IDENT')        { |i| Ricola::VariableReference.new(i)  }
			end

			list(:expr_list, :expr, :COMMA)

			finalize
		end
	end
end

