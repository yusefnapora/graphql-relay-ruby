
module GraphQL::Relay

  def plural_identifying_root_field(arg_name:, input_type:, output_type:, resolve_single_input:, desc: nil)
    GraphQL::Field.define do
      if desc
        description desc
      end

      type types[output_type],
      argument arg_name, !types[!input_type]

      # TODO: Promises?  What's the concurrency story for ruby like in 2015?
      resolve -> (_, args, _) {
        inputs = args[arg_name]
        inputs.map do |input|
          resolve_single_input.call(input)
        end
      }
    end
  end
end