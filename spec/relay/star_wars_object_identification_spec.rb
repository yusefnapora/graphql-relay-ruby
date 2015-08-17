require 'spec_helper'
require_relative '../support/star_wars_schema'

describe 'Object Identification Tests' do
  describe 'Fetching Tests' do
    it 'Correctly fetches the ID and name of the rebels' do
      query_string = %|
        query RebelsQuery {
          rebels {
            id
            name
          }
        }
      |

      expected = { 'data' => {
          'rebels' => {
            'id' => 'RmFjdGlvbjox',
            'name' => 'Alliance to Restore the Republic'
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly refetches the rebels' do
      query_string = %|
        query RebelsRefetchQuery {
          node(id: "RmFjdGlvbjox") {
            id
            ... on Faction {
              name
            }
          }
        }
      |
      expected = {'data' => {
          'node' => {
              'id' => 'RmFjdGlvbjox',
              'name' => 'Alliance to Restore the Republic'
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly fetches the ID and name of the empire' do
      query_string = %|
        query EmpireQuery {
          empire {
            id
            name
          }
        }
      |
      expected = {'data' => {
          'empire' => {
              'id' => 'RmFjdGlvbjoy',
              'name' => 'Galactic Empire'
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly refetches the empire' do
      query_string = %|
        query EmpireRefetchQuery {
          node(id: "RmFjdGlvbjoy") {
            id
            ... on Faction {
              name
            }
          }
        }
      |
      expected = {'data' => {
          'node' => {
              'id' => 'RmFjdGlvbjoy',
              'name' => 'Galactic Empire'
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly refetches the X-Wing' do
      query_string = %|
        query XWingRefetchQuery {
          node(id: "U2hpcDox") {
            id
            ... on Ship {
              name
            }
          }
        }
      |
      expected = {'data' => {
          'node' => {
              'id' => 'U2hpcDox',
              'name' => 'X-Wing'
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end
  end
end