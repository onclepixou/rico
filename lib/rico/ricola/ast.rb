require 'colorize'

module Rico
	module Ricola

		class Node
			
			attr_reader :children # @return [Array{Node}]
			attr_reader :parent   # @return [Node, nil]
			attr_accessor :contractor_variable #return String

			def initialize(*children)
				@parent = nil
				@contractor_variable = ""
				@children = children.collect do |c|
					check_if_node(c)
					c.parent = self
					c
				end
			end

			def parent=(p)
				check_if_node(p)
				raise "parent already set" unless @parent.nil?
				@parent = p
			end

			def check_if_node(n)
				raise "expecting a #{self.class}, not a #{n.class}" unless n.is_a?(Node)
				n
			end

			def to_s(prefix = '', last = true, first = true)
				str = prefix + (first ? '' : (last ? '└─ ' : '├─ '))
				str += to_s_header + "\n"
				prefix = prefix + (first ? '' :(last ? '   ' : '│  '))
				@children.each_with_index do |c, i|
					str += c.to_s(prefix, (i+1 == @children.length), false)
				end
				str
			end

			def to_s_header
				"#{self.class.name.sub(/^.+::/, '').light_blue.bold}"
			end
		end


		class Program < Node
			def initialize(isec, osec, csec)
				super
			end

			def input_section
				@children[0]
			end

			def output_section
				@children[1]
			end

			def constraint_section
				@children[2]
			end
		end


		class DeclarationList < Node
			def initialize(decl_arr)
				super(*decl_arr)
			end
		end


		class InputSection < DeclarationList
			def initialize(decl_arr)
				super
			end
		end


		class OutputSection < DeclarationList
			def initialize(decl_arr)
				super
			end
		end


		class Declaration < Node
			attr_reader :id           # @return [String]
			attr_reader :operand_type # @return [Symbol] either :interval or :scalar
			attr_reader :data_type    # @return [Symbol] either :integer or :float

			def initialize(t, i, d)
				super()
				@operand_type = t
				@id = i
				@data_type = d
			end

			def to_s_header
				"#{super()} ID: #{@id.to_s.light_green.bold}, OPERAND_TYPE: #{@operand_type.to_s.light_green.bold}, DATA_TYPE: #{@data_type.to_s.light_green.bold}"
			end
		end


		class ConstraintList < Node
			def initialize(constraint_arr)
				super(*constraint_arr)
			end
		end


		class Constraint < Node
			attr_reader :id # @return [String]

			def initialize(id, expr)
				super(expr)
				@id = id
			end

			def to_s_header
				"#{super()} ID: #{@id.to_s.light_green.bold}"
			end
		end


		class BinOp < Node

			def initialize(l, r)
				super
			end

			def lhs; children[0]; end
			def rhs; children[1]; end
		end


		class Comparizon < BinOp
			def initialize(l, r)
				super
			end
		end


		class Equal < Comparizon
			def initialize(l, r)
				super
			end
		end

		class LowerThan < Comparizon
			def initialize(l, r)
				super
			end
		end

		class LowerEqual < Comparizon
			def initialize(l, r)
				super
			end
		end

		class GreaterThan < Comparizon
			def initialize(l, r)
				super
			end
		end

		class GreaterEqual < Comparizon
			def initialize(l, r)
				super
			end
		end

		class Add < BinOp
			def initialize(l, r)
				super
			end
		end
		class Sub < BinOp
			def initialize(l, r)
				super
			end
		end
		class Mul < BinOp
			def initialize(l, r)
				super
			end
		end
		class Div < BinOp
			def initialize(l, r)
				super
			end
		end
		class Pow < BinOp
			def initialize(l, r)
				super
			end
		end

		class Number < Node
			attr_reader :value # @return [Float]

			def initialize(v)
				super()
				@value = v
			end

			def to_s_header
				"#{super()} VALUE: #{@value.to_s.light_magenta.bold}"
			end
		end

		class VariableReference < Node
			attr_reader :id # @return [String]

			def initialize(id)
				super()
				@id = id
			end

			def to_s_header
				"#{super()} ID: #{@id.to_s.light_green.bold}"
			end
		end

		class FunctionCall < Node
			attr_reader :id # @return [String]

			def initialize(id, expr)
				super(*expr)
				@id = id
			end

			def to_s_header
				"#{super()} ID: #{@id.to_s.light_green.bold}"
			end
		end
	end
end

