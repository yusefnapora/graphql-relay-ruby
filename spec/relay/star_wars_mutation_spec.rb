require 'spec_helper'
require_relative '../support/star_wars_schema'

describe 'Mutation Tests' do
  it 'Correctly mutates the data set' do
    mutation_string = %|
    mutation AddBWingQuery($input: IntroduceShipInput!) {
        introduceShip(input: $input) {
          ship {
            id
            name
          }
          faction {
            name
          }
          clientMutationId
        }
      }
    |

    params = {
        'input' => {
            'shipName' => 'B-Wing',
            'factionId' => '1',
            'clientMutationId' => 'abcde'
        }
    }

    expected = {'data' => {
        'introduceShip' => {
            'ship' => {
                'id' => 'U2hpcDo5',
                'name' => 'B-Wing'
            },
            'faction' => {
                'name' => 'Alliance to Restore the Republic'
            },
            'clientMutationId' => 'abcde'
        }
    }}

    mutation = GraphQL::Query.new(StarWarsSchema, mutation_string, variables: params)
    assert_equal(expected, mutation.result)
  end

end