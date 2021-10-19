require_relative './ast.rb'
require_relative './functions.rb'

module Rico

	module Ricola

        class SemanticAnalyzer

        	attr_reader :ast                   # return Root Node
        	attr_accessor :variable_decl_valid    # return Boolean
        	attr_accessor :constr_decl_valid   # return Boolean
        	attr_reader :declared_variables    # Hash map variableName (string) --> Array[operand_type (string), data_type (string)]

            def initialize(ast)

            	@ast = ast
            	@variable_decl_valid = true 
            	@constr_decl_valid = true
            	@declared_variables = Hash.new

            	load_declared_variables()
            	check_expressions()
            end

            def load_declared_variables()
			
				@ast.children.each_with_index do |n, i|
					
                    if(n.is_a? InputSection)
                        
                        add_variables(n)
                    end

                    if(n.is_a? OutputSection)
                        
                        add_variables(n)
                    end
				end
            end

            def add_variables(input)

            	begin

                	input.children.each_with_index do |n, i|
					
                    	if(n.is_a? Declaration)
                        
                        	if(@declared_variables.key?(n.id))

                            	raise Exception.new("Variable " + n.id + " already declared")
                        	else 

                            	@declared_variables[n.id] = [n.operand_type, n.data_type]
                        	end
                    	end
					end

				rescue Exception => e

					puts e.message
					@variable_decl_valid = false;
				end
            end

            def check_expressions()

            	begin 
                	@ast.children.each_with_index do |n, i|
						
						# look for constraintList node
                	    if(n.is_a? ConstraintList)
                	        
                	        # Evaluate each constrain separately
                	        n.children.each_with_index do | e, j|

                        		check_constraint(e)
                        	end
                    	end
					end  

				rescue Exception => e 
					puts e.message
					@constr_decl_valid = false;
				end
            end

            def check_constraint(c)

            	c.children.each_with_index do |n, i|

					if(n.is_a? VariableReference)
                        
                    	if(!@declared_variables.key?(n.id))

                    		raise Exception.new("VariableReference " + n.id + " has never been declared")
                    		return false
                    	end
                	end

            		check_constraint(n)
            	end
            end

            def is_valid()

            	return (@variable_decl_valid and @constr_decl_valid)
            end

        end
    end
end