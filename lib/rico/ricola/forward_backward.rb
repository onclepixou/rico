require_relative './ast.rb'
#require 'Enumerable.rb'

module Rico

	module Ricoco

		class ConstraintNode

			attr_reader :node  # return Ast Node
			attr_reader :var   # return var name (string)
			attr_reader :depth # return depth (integer) 
			attr_reader :side  # return string ("left" or "right")

			def initialize(node, var, depth, side)

				@node = node
				@var = var
				@depth = depth
				@side = side
			end

			def to_s()

				return "Constraint : depth : " + @depth.to_s + " variable : " + @var.to_s + " side : " + side + " node : \n" + @node.to_s
			end
		end

		class ForwardBackward
			
			#attr_reader :ast                   # return Root Node
			#attr_reader :constraint_nodes      # Hash map variableName (constr_name) --> Array[ConstraintNodes]

			def initialize(ast)

				@ast = ast
				@current_id = 1
				@constraint_nodes = Hash.new
				@declared_variables = Hash.new

				build_constraints()

				@constraint_nodes.each_key do |k|

					puts "def " + k + "() : " 

					forward(k)
					backward(k)
					puts("")
				end
			end

			def get_variable_id()

				value = @current_id
				@current_id +=1
				return "v"+value.to_s
			end

			def get_printable_var(n)

				if(n.is_a? String)

					return n
				end

				if(n.contractor_variable != "")

					return n.contractor_variable
				end

				if(n.respond_to?(:id))

					return n.id
				end

				if(n.respond_to?(:value))

					return n.value
				end

				raise "No proper printing found"
				
			end

			def contractor_printer(name, array)

				str = ""
				array.each_with_index { |x, i| 

					str += get_printable_var(x)
	
					if( i != (array.size() -1 ))
							
						str += ', '
					end
				}

				str += " = " + name + "("

				array.each_with_index { |x, i| 

					str += get_printable_var(x)
	
					if( i != (array.size() -1 ))
							
						str += ','
					end
				}

				str += ")"
			
				return str
			end

			def build_constraints()

				@ast.children.each_with_index do |n, i|
						
					# look for constraintList node
                	if(n.is_a? Rico::Ricola::ConstraintList)
                	        
                	    # Evaluate each constrain separately
                	    n.children.each_with_index do | e, j|

                	    	@constraint_nodes[e.id.to_s] = Array.new
                        	build_constraint_node(e.children[0], 0, "", e.id.to_s)
                        end
                    end
				end
			end

			def build_constraint_node(n, depth, side, constr)

				if(n.is_a? Rico::Ricola::Equal)

					build_constraint_node(n.children[0], 0, "right", constr)
					build_constraint_node(n.children[1], 0, "left", constr)

				elsif(n.children.length() != 0)
					
					if(depth == 0)

						n.contractor_variable = "v0"
					else

						n.contractor_variable = get_variable_id()
					end

					@constraint_nodes[constr].append(ConstraintNode.new(n, n.contractor_variable, depth + 1, side))

					n.children.each_with_index do |c,i|

						build_constraint_node(c, depth + 1, side, constr)

					end
				end
			end

			def forward(k)

				puts "\t#######FORWARD#######"
				# sort stuff according to depth
				constraints = @constraint_nodes[k]
				constraints.sort!{|a,b| b.depth <=> a.depth}

				constraints.each do |obj| 
	
					if( (obj.depth == 1 ) and (obj.side == "left"))

						# this will be done in backward
						next
					end

					if(obj.node.is_a? Rico::Ricola::Pow)
						
						power = obj.node.children[1].value

						if(power == 2)

							puts "\t" + obj.var.to_s + " = sqr(" + get_printable_var(obj.node.children[0])  + ")"

						else

							raise "Power with value " + power.to_s + " is not yet supported"
						end

					elsif (obj.node.is_a? Rico::Ricola::Add)

						puts "\t" + obj.var.to_s + " = " + get_printable_var(obj.node.children[0])  + " + " + get_printable_var(obj.node.children[1])

					elsif (obj.node.is_a? Rico::Ricola::Sub)

						puts "\t" + obj.var.to_s + " = " + get_printable_var(obj.node.children[0])  + " - " + get_printable_var(obj.node.children[1])

					else

						puts "unknown"

					end
				end

				puts "\t#####################"
			end

			def backward(k)

				puts "\t#######BACKWARD######"

				# sort stuff according to depth
				constraints = @constraint_nodes[k]
				constraints.sort!{|a,b| a.depth <=> b.depth}

				constraints.each do |obj| 
	
					if( obj.node.is_a? Rico::Ricola::Pow )

						power = obj.node.children[1].value

						if(power == 2)

							puts "\t" + contractor_printer("Csqr_rev", [obj.var, obj.node.children[0]])

						else

							raise "Power with value " + power.to_s + " is not yet supported"
						end

					elsif (obj.node.is_a? Rico::Ricola::Add)

						puts "\t" + contractor_printer("Cadd_rev", [obj.var, obj.node.children[0], obj.node.children[1]])
						puts "\t" + contractor_printer("Csub_rev", [obj.node.children[0], obj.var, obj.node.children[1]])
						puts "\t" + contractor_printer("Csub_rev", [obj.node.children[1], obj.var, obj.node.children[0]])

					elsif (obj.node.is_a? Rico::Ricola::Sub)

						puts "\t" + contractor_printer("Csub_rev", [obj.var, obj.node.children[0], obj.node.children[1]])
						puts "\t" + contractor_printer("Cadd_rev", [obj.node.children[0], obj.var, obj.node.children[1]])
						puts "\t" + contractor_printer("Csub_rev", [obj.node.children[1], obj.node.children[0], obj.var])

					else

						puts "unknown"

					end					
				end	
				puts "\t#####################"		
			end
        end
    end
end