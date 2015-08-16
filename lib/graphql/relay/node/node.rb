
require 'base64'

module GraphQL
  module Relay

    ##
    # Given a function to map from an ID to an underlying object, and a function
    # to map from an underlying object to the concrete GraphQL::ObjectType it
    # corresponds to, constructs a `Node` interface that objects can implement,
    # and a field config for a `node` root field.
    def node_definitions(id_fetcher, type_resolver)
      node_interface = GraphQL::InterfaceType.define do
        name 'Node'
        description 'An object with an ID'
        field :id, !types.ID, 'The id of the object.'
        resolve_type(type_resolver)
      end

      node_field = GraphQL::Field.define do
        name 'node'
        description 'Fetches an object given its ID'
        type node_interface
        argument :id, !types.ID, 'The ID of an object'
        resolve -> (obj, arguments, context) { id_fetcher(arguments.id) }
      end

      {node_interface: node_interface, node_field: node_field}
    end


    ##
    # Takes a type name and an ID specific to that type name, and returns a
    # "global ID" that is unique among all types
    def to_global_id(type, id)
      Base64.encode([type, id].join(':'))
    end

    ##
    # Takes the "global ID" created by to_global_id, and returns the type name and ID
    # used to create it.
    def from_global_id(global_id)
      tokens = Base64.decode(global_id).split(':', 2)
      {type: tokens[0], id: tokens[1]}
    end

    ##
    # Creates the configuration for an id field on a node, using `to_global_id` to
    # construct the ID from the provided typename. The type-specific ID is fetched
    # by calling idFetcher on the object, or if not provided, by accessing the `id`
    # property on the object.
    def global_id_field(type_name, id_fetcher = nil)
      {
          name: 'id',
          description: 'The ID of an object',
          type: GraphQL::NonNullType.new(of_type: GraphQL::ID_TYPE),
          resolve: -> (obj, args, ctx) { to_global_id(type_name, id_fetcher || obj['id']) }
      }
    end

  end
end