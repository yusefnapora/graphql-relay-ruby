module Relay

  ##
  # Returns a field configuration for the mutation described by the
  # provided mutation config
  def mutation_with_client_mutation_id(name:, input_fields:, output_fields:, mutate_and_get_payload:)

    input_type = GraphQL::InputObjectType.define do
      name "#{name}Input"
      input_field :clientMutationId, !types.String
    end

    input_fields.each do |k, v|
      input_type.input_fields[k.to_s] = v
    end

    output_type = GraphQL::ObjectType.define do
      name "#{name}Payload"
      field :clientMutationId, !types.String
      output_fields.each do |k,v|
        field k, field: v
      end
    end

    GraphQL::Field.define do
        type !output_type
        argument :input, !input_type

        resolve  -> (_, args, _) {
          payload = mutate_and_get_payload.call(args[:input])
          payload[:clientMutationId] = args[:input]['clientMutationId']
          payload
        }
    end
  end

end