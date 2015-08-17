require 'spec_helper'
require_relative '../support/star_wars_schema'

describe 'Connection Tests' do
  describe 'Fetching Tests' do

    it 'Correctly fetches the first ship of the rebels' do
      query_string = %|
        query RebelsShipsQuery {
          rebels {
            name,
            ships(first: 1) {
              edges {
                node {
                  name
                }
              }
            }
          }
        }
      |
      expected = {'data' => {
          'rebels' => {
              'name' => 'Alliance to Restore the Republic',
              'ships' => {
                  'edges' => [
                      {
                          'node' => {
                              'name' => 'X-Wing'
                          }
                      }
                  ]
              }
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

  end
end