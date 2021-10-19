require_relative './ast.rb'
#require 'Enumerable.rb'

module Rico

	module Interval

		class ConstraintNode

			attr_reader :node  # return Ast Node
			attr_reader :var   # return var name (string)
			attr_reader :depth # return depth (integer) 

			def initialize(node, var, depth )

				@node = node
				@var = var
				@depth = depth
			end

			def to_s()

				return "Constraint : depth : " + @depth.to_s + " variable : " + @var.to_s + " node : \n" + @node.to_s
			end
		end

		class ForwardBackward
			
			attr_reader :ast                   # return Root Node
			attr_reader :constraint_nodes      # return Array(ConstraintNode)

			def initialize(ast)

				@ast = ast
				@current_id = 1
				@constraint_nodes = Array.new
				build_constraints()
				forward()
				backward()

			end

			def get_variable_id()

				value = @current_id
				@current_id +=1
				return "v"+value.to_s
			end

			def build_constraints()

				@ast.children.each_with_index do |n, i|
						
					# look for constraintList node
                	if(n.is_a? Rico::Ricola::ConstraintList)
                	        
                	    # Evaluate each constrain separately
                	    n.children.each_with_index do | e, j|

                        	build_constraint_node(e.children[0], 0)
                        end
                    end
				end
			end

			def build_constraint_node(n, depth)

				if(n.is_a? Rico::Ricola::Equal)

					build_constraint_node(n.children[0], 0)
					build_constraint_node(n.children[1], 0)

				elsif(n.children.length() != 0)

					@constraint_nodes.append(ConstraintNode.new(n, get_variable_id(), depth + 1))

					n.children.each_with_index do |c,i|

						build_constraint_node(c, depth + 1 )

					end
				end
			end

			def forward()

				# sort stuff according to depth
				constraints = @constraint_nodes
				constraints.sort!{|a,b| a.depth <=> b.depth}

				constraints.each do |obj| 
	
					puts obj

					if(obj.node.is_a? Rico::Ricola::Pow)

						puts "pow"

					elsif (obj.node.is_a? Rico::Ricola::Sub)

						puts "sub"

					elsif (obj.node.is_a? Rico::Ricola::Add)

						puts "add"

					else

						puts "unknown"

					end
				end
			end

			def backward()

				# sort stuff according to depth
				constraints = @constraint_nodes
				constraints.sort!{|a,b| b.depth <=> a.depth}

				constraints.each do |obj| 
	
				end			
			end

        end
    end
end