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

    it 'Correctly fetches the first two ships of the rebels with a cursor' do
      query_string = %|
        query MoreRebelShipsQuery {
          rebels {
            name,
            ships(first: 2) {
              edges {
                cursor,
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
                          'cursor' => 'YXJyYXljb25uZWN0aW9uOjA=',
                          'node' => {
                              'name' => 'X-Wing'
                          }
                      },
                      {
                          'cursor' => 'YXJyYXljb25uZWN0aW9uOjE=',
                          'node' => {
                              'name' => 'Y-Wing'
                          }
                      }
                  ]
              }
          }
      }}

      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly fetches the next three ships of the rebels with a cursor' do
      query_string = %|
        query EndOfRebelShipsQuery {
          rebels {
            name,
            ships(first: 3, after: "YXJyYXljb25uZWN0aW9uOjE=") {
              edges {
                cursor,
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
                          'cursor' => 'YXJyYXljb25uZWN0aW9uOjI=',
                          'node' => {
                              'name' => 'A-Wing'
                          }
                      },
                      {
                          'cursor' => 'YXJyYXljb25uZWN0aW9uOjM=',
                          'node' => {
                              'name' => 'Millenium Falcon'
                          }
                      },
                      {
                          'cursor' => 'YXJyYXljb25uZWN0aW9uOjQ=',
                          'node' => {
                              'name' => 'Home One'
                          }
                      }
                  ]
              }
          }
      }}
      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly fetches no ships of the rebels at the end of the connection' do
      query_string = %|
        query RebelsQuery {
          rebels {
            name,
            ships(first: 3, after: "YXJyYXljb25uZWN0aW9uOjQ=") {
              edges {
                cursor,
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
                  'edges' => []
              }
          }
      }}

      query = GraphQL::Query.new(StarWarsSchema, query_string, debug: false, operation_name: nil)
      assert_equal(expected, query.result)
    end

    it 'Correctly identifies the end of the list' do
      query_string = %|
        query EndOfRebelShipsQuery {
          rebels {
            name,
            originalShips: ships(first: 2) {
              edges {
                node {
                  name
                }
              }
              pageInfo {
                hasNextPage
              }
            }
            moreShips: ships(first: 3, after: "YXJyYXljb25uZWN0aW9uOjE=") {
              edges {
                node {
                  name
                }
              }
              pageInfo {
                hasNextPage
              }
            }
          }
        }
      |

      expected = {'data' => {
          'rebels' => {
              'name' => 'Alliance to Restore the Republic',
              'originalShips' => {
                  'edges' => [
                      {
                          'node' => {
                              'name' => 'X-Wing'
                          }
                      },
                      {
                          'node' => {
                              'name' => 'Y-Wing'
                          }
                      }
                  ],
                  'pageInfo' => {
                      'hasNextPage' => true
                  }
              },
              'moreShips' => {
                  'edges' => [
                      {
                          'node' => {
                              'name' => 'A-Wing'
                          }
                      },
                      {
                          'node' => {
                              'name' => 'Millenium Falcon'
                          }
                      },
                      {
                          'node' => {
                              'name' => 'Home One'
                          }
                      }
                  ],
                  'pageInfo' => {
                      'hasNextPage' => false
                  }
              }
          }
      }}
    end

  end
end