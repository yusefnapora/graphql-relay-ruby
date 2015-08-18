require 'spec_helper'
require 'relay'
include Relay

user_data = {
    '1' => {
        'id' => 1,
        'name' => 'John Doe'
    },
    '2' => {
        'id' => 2,
        'name' => 'Jane Smith'
    }
}

photo_data = {
    '3' => {
        'id' => 3,
        'width' => 300
    },
    '4' => {
        'id' => 4,
        'width' => 400
    }
}

node_defs = node_definitions(
  -> (id, info) {
    
  },

  -> (obj) {

  }
)