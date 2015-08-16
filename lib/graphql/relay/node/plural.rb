
module GraphQL::Relay

  def plural_identifying_root_field(config)
    input_args = {}
    input_args[config[:arg_name]] = {
        type: GraphQL::NonNullType.new(
            of_type: GraphQL::ListType.new(
                of_type: GraphQL::NonNullType(
                    of_type: config[:input_type])))
    }

    {
        description: config[:description],
        type: GraphQL::ListType.new(of_type: config[:output_type]),
        args: input_args,

        # TODO: Promises?  What's the concurrency story for ruby like in 2015?
        resolve: -> (obj, args, ctx) {
          inputs = args[config[:arg_name]]
          resolve_single = config[:resolve_single_input]
          inputs.map do |input|
            resolve_single.call(input)
          end
        }
    }
  end
end