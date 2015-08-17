
require 'relay'
include Relay

require_relative './star_wars_data'

node_definitions = Relay.node_definitions(
  # Given a global id, return the object it identifies
  -> (global_id) {
    local_id = Relay.from_global_id(global_id)
    type, id = local_id.values_at(:type, :id)
    if type == 'Faction'
      return get_faction(id)
    end
    if type == 'Ship'
      return get_ship(id)
    end
    return nil
  },

  # Given an object, return it's GraphQL type
  -> (obj) {
    obj.ships ? FactionType : ShipType
  })

NodeInterface, NodeField = node_definitions.values_at(:node_interface, :node_field)

ShipType = GraphQL::ObjectType.define do
  name 'Ship'
  description 'A ship in the Star Wars saga'
  interfaces([NodeInterface])

  field :id, field: Relay.global_id_field('Ship')
  field :name, types.String, 'The name of the ship.'
end

ShipConnection = Relay.connection_definitions(name: 'Ship', node_type: ShipType).values_at(:connection_type)

FactionType = GraphQL::ObjectType.define do
  name 'Faction'
  description 'A faction in the Star Wars saga'
  field :id, field: Relay.global_id_field('Faction')
  field :name, types.String, 'The name of the faction.'
  field :ships do
    type ShipConnection
    description 'The ships used by the faction.'
    arguments=(Relay.connection_args)
    resolve -> (faction, args, _) {
      Relay.connection_from_array(faction.ships.map {|id| get_ship(id)}, args)
    }
  end
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  field :rebels do
    type FactionType
    resolve -> (_,_,_) { get_rebels }
  end

  field :empire do
    type FactionType
    resolve -> (_,_,_) { get_empire }
  end

  field :node, field: NodeField
end

ShipMutation = Relay.mutation_with_client_mutation_id(
    name: 'IntroduceShip',
    input_fields: {
        shipName: GraphQL::Field.define { type !types.String },
        factionId: GraphQL::Field.define { type !types.ID }
    },
    output_fields: {
        ship: GraphQL::Field.define {
          type ShipType
          resolve -> (payload) { get_ship(payload[:shipId]) }
        },
        faction: GraphQL::Field.define {
          type FactionType
          resolve -> (payload) { get_faction(payload[:factionId])}
        }
    },
    mutate_and_get_payload: -> (args) {
      ship_name, faction_id = args.values_at(:shipName, :factionId)
      new_ship = create_ship(ship_name, faction_id)
      {
          shipId: new_ship.id,
          factionId: faction_id
      }
    }
)


MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  field :introduceShip, field: ShipMutation
end

StarWarsSchema = GraphQL::Schema.new(query: QueryType, mutation: MutationType)

