require_relative './ast.rb'
#require 'Enumerable.rb'

module Rico

	module Ricola

		class ForwardBackward
			

			def initialize(constr)

				@decorated_constraints = Hash.new()
				@current_var = 0
				@intermediate_arr = Array.new()

                constr.each do |key, value|

                    @decorated_constraints[key] = [constr[key][0], decorate_constraint(constr[key][0].id, constr[key][1], 0)]
                end

				forward()

			end

			def decorate_constraint(topvar, node, depth)

				if(node.parent.is_a? Equal)
					node.intermediate_variable = topvar
					node.depth = depth
					@intermediate_arr.append(node)

					node.children.collect do |n|

						decorate_constraint(topvar, n, depth + 1)
					end

				else

					if(!node.children.empty?)

						node.intermediate_variable = "v" + new_intermediate_variable().to_s
						node.depth = depth
						@intermediate_arr.append(node)

						node.children.collect do |n|

							decorate_constraint(topvar, n, depth + 1)
						end
					end
				end
			end

			def new_intermediate_variable()

				@current_var += 1
				@current_var
			end

			def forward()
			
				@intermediate_arr.sort_by{|obj| obj.depth}

				@intermediate_arr.collect do |n|

					print("Cmul(" + n.intermediate_variable.to_s + "\n" )#n.children[0].id.to_s + "," + n.children[1].id.to_s + ")")
				end

			end
        end
    end
end