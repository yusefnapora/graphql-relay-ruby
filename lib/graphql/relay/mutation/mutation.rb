module GraphQL::Relay

  ##
  # Returns a field configuration for the mutation described by the
  # provided mutation config
  def mutation_with_client_mutation_id(name:, input_fields:, output_fields:, mutate_and_get_payload:)
    augmented_input_fields = input_fields.merge({
      clientMutationId: GraphQL::NonNullType.new(of_type: GraphQL::STRING_TYPE)
    })

    augmented_output_fields = output_fields.merge({
      clientMutationId: GraphQL::NonNullType.new(of_type: GraphQL::STRING_TYPE)
    })

    output_type = GraphQL::ObjectType.define do
      name "#{name}Payload"
      augmented_output_fields.each do |field_name,field_definition|
        field field_name, field_definition
      end
    end

    input_type = GraphQL::InputObjectType.define do
      name "#{name}Input"
      augmented_input_fields.each do |field_name, field_definition|
        field field_name, field_definition
      end
    end

    GraphQL::ObjectType.define do
        type output_type
        argument :input, !input_type
        resolve  -> (_, args) {
          payload = mutate_and_get_payload.call(args[:input])
          payload[:clientMutationId] = args[:input][:clientMutationId]
          payload
        }
    end
  end

end