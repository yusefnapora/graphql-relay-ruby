require 'spec_helper'
require_relative '../support/star_wars_schema'

describe 'Object Identification Tests' do
  describe 'Fetching Tests' do
    let(:query_string) { %|
        query RebelsQuery {
          rebels {
            id
            name
          }
        }
      |}
    let(:query) {
      GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
    }
    let(:result) { query.result }

    it 'Correctly fetches the ID and name of the rebels' do

      expected = { 'data' => {
          'rebels' => {
            'id' => 'RmFjdGlvbjox',
            'name' => 'Alliance to Restore the Republic'
          }
      }}
      assert_equal(expected, result)
    end

  end
end