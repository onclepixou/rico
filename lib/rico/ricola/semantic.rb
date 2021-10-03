require_relative './ast.rb'
require_relative './functions.rb'

module Rico

	module Ricola

        class SemanticAnalyzer

            attr_reader :constraints

            def initialize(ast)
                @ast = ast
                @variables = Hash.new
                @constraints = Hash.new
                @calls = SupportedFunctionCalls.new
                check_declarations()
                check_contrainsts()
            end

            def is_variable(var)

                return @variables.key?(var)             
            end

            def is_input_variable(var)

                return ( @variables.key?(var) and @variables[var][0] == "input")
            end

            def is_output_variable(var)

                return ( @variables.key?(var) and @variables[var][0] == "output")
            end

            def check_declarations()
                @ast.children.each_with_index do |n, i|
					
                    if(n.is_a? InputSection)
                        
                        add_variables(n, "input")
                    end

                    if(n.is_a? OutputSection)
                        
                        add_variables(n, "output")
                    end
				end
            end

            def check_contrainsts()
                @ast.children.each_with_index do |n, i|
					
                    if(n.is_a? ConstraintList)
                        
                        add_constraint(n)
                    end
				end

                output_defined = Set.new

                @constraints.each do |key, value|
                
                    output_var = value[0].id

                    if(!is_output_variable(output_var))

                        raise output_var + " is not a declared output variable\n"
                    end

                    if(@variables[output_var][3] == true)

                        raise output_var + " has already been given constraints\n"
                    end

                    @variables[output_var][3] = true

                    check_contrainsts_rhs(value[1], output_var)
                end
            end

            def check_contrainsts_rhs(rhs, output_var)

                rhs.children.each_with_index do |n, i|
					
                    if(n.is_a? VariableReference)
                        
                        if(!is_variable(n.id))
                            
                            raise n.id + " was not declared in the program"
                        end

                        if(n.id == output_var)
                            
                            raise n.id + " cannot be in right side of the equation"
                        end
                    end

                    if(n.is_a? FunctionCall)

                        if(!@calls.supports_call(n.id))

                            raise "Unknown function call " + n.id
                        end

                        if(@calls.arg_nb(n.id) != n.children.length)

                            raise "Bad number of argument for function call " + n.id + ". Expected " + @calls.arg_nb(n.id).to_s + ", got " + n.children.length.to_s
                        end

                    end

                    check_contrainsts_rhs(n, output_var)
				end
            end

            def add_variables(input, decl_type)
                input.children.each_with_index do |n, i|
					
                    if(n.is_a? Declaration)
                        
                        if(@variables.key?(n.id))

                            raise Exception.new("Variable " + n.id + " already declared")
                        else 

                            @variables[n.id] = [decl_type, n.operand_type, n.data_type, false]
                        end
                    end
				end
            end

            def add_constraint(constr)
                constr.children.each_with_index do |n, i|
					
                    if(n.is_a? Constraint)
                        if(@constraints.key?(n.id))

                            raise Exception.new("Constraint Id " + n.id + " already declared")
                        else 

                            if(n.children[0].is_a? Equal)

                                @constraints[n.id] = [n.children[0].lhs, n.children[0].rhs]
                            end
                        end
                    end
                end
            end
        end
    end
end