
module Relay

  ##
  # The common page info type used by all connections
  #
  PageInfoType = GraphQL::ObjectType.define do
    name 'PageInfo'
    description 'Information about pagination in a connection.'
    field :hasNextPage, !types.Boolean, 'When paginating forwards, are there more items?'
    field :hasPreviousPage, !types.Boolean, 'When paginating backwards, are there more items?'
    field :startCursor, types.String, 'When paginating backwards, the cursor to continue.'
    field :endCursor, types.String, 'When pagniating forwards, the cursor to continue.'
  end


  def resolve_maybe_thunk(thing_or_thunk)
    thing_or_thunk.is_a?(Proc) ? thing_or_thunk.call : thing_or_thunk
  end

  ##
  # Returns input arguments for a connection type
  def connection_args
    {
        before: GraphQL::Argument.define { type types.String },
        after: GraphQL::Argument.define { type types.String },
        first: GraphQL::Argument.define { type types.Int },
        last: GraphQL::Argument.define { type types.Int }
    }
  end

  ##
  # Returns a GraphQL::ObjectType for a connection with the given name,
  # and whose nodes are of the specified type.
  def connection_definitions(name: name, node_type: node_type, edge_fields: edge_fields = {}, connection_fields: connection_fields = {})
    edge_fields = resolve_maybe_thunk(edge_fields)
    connection_fields = resolve_maybe_thunk(connection_fields)


    edge_type = GraphQL::ObjectType.define do
      name "#{name}Edge"
      description 'An edge in a connection.'
      field :node, node_type, 'the item at teh end of the edge'
      field :cursor, !types.String, 'A cursor for use in pagination'

      edge_fields.each do |k,v|
        field_name = k.to_s.to_sym
        field field_name, v
      end
    end

    connection_type = GraphQL::ObjectType.define do
      name "#{name}Connection"
      description 'A connection to a list of items.'
      field :pageInfo, !PageInfoType, 'Information to aid in pagination.'
      field :edges, !edge_type, 'Information to aid in pagination.'

      connection_fields.each do |k,v|
        field_name = k.to_s.to_sym
        field field_name, v
      end
    end

      {edge_type: edge_type, connection_type: connection_type}
    end
end