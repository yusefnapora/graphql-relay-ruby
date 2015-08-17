
require '../../lib/graphql/relay'
require '../support/star_wars_data'

node_definitions = GraphQL::Relay.node_definitions(
  -> (global_id) {
    local_id = GraphQL::Relay.from_global_id(global_id)
    type, id = local_id.values_at(:type, :id)
    if type == 'Faction'
      return
    end
  },

  -> (obj) {
    obj.ships ? faction_type : ship_type
  })

ship_type = GraphQL::ObjectType.define do
  name 'Ship'
  description 'A ship in the Star Wars saga'
  field do

  end
end
