module GraphQL::Relay

  ##
  # Returns a field configuration for the mutation described by the
  # provided mutation config
  def mutation_with_client_mutation_id(config)
    name, input_fields, output_fields, mutate_and_get_payload =
        config.values_at(:name, :inputFields, :outputFields, :mutateAndGetPayload)
    augmented_input_fields = input_fields.merge {
      clientMutationId: GraphQL::NonNullType.new(of_type: GraphQL::STRING_TYPE)
    }

    augmented_output_fields = output_fields.merge {
      clientMutationId: GraphQL::NonNullType.new(of_type: GraphQL::STRING_TYPE)
    }

    output_type =
  end

end