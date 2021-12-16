module Rico
	module Ricola

        class SupportedFunctionCalls

            attr_reader :supported_calls

            def initialize()

                @supported_calls = Hash.new()
                load_calls()
            end

            def load_calls()

                @supported_calls["cos"] = [1, [:any]]
            end

            def supports_call(id)

                @supported_calls.key?(id)
            end

            def arg_nb(id)

                if(!supports_call(id))

                    raise "function call no supported : " + id
                end
                @supported_calls[id][0]
            end
        end
    end
end