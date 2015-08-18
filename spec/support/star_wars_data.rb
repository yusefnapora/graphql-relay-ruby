require 'ostruct'

xwing = OpenStruct.new({id: '1', name: 'X-Wing'})
ywing = OpenStruct.new({id: '2', name: 'Y-Wing'})
awing = OpenStruct.new({id: '3', name: 'A-Wing'})
falcon = OpenStruct.new({id: '4', name: 'Millenium Falcon'})
home_one = OpenStruct.new({id: '5', name: 'Home One'})

tie_fighter = OpenStruct.new({id: '6', name: 'TIE Fighter'})
tie_interceptor = OpenStruct.new({id: '7', name: 'TIE Interceptor'})
executor = OpenStruct.new({id: '8', name: 'Executor'})

REBELS = OpenStruct.new({
    id: '1',
    name: 'Alliance to Restore the Republic',
    ships: %w{1 2 3 4 5}
})

EMPIRE = OpenStruct.new({
    id: '2',
    name: 'Galactic Empire',
    ships: %w{6 7 8}
})

DATA = {
    Faction: {
        '1' => REBELS,
        '2' => EMPIRE
    },
    Ship: {
        '1' => xwing,
        '2' => ywing,
        '3' => awing,
        '4' => falcon,
        '5' => home_one,
        '6' => tie_fighter,
        '7' => tie_interceptor,
        '8' => executor
    }
}

$next_ship = 9

def create_ship(ship_name, faction_id)
  ship_id = $next_ship
  $next_ship += 1
  new_ship = OpenStruct.new({
      id: ship_id.to_s,
      name: ship_name
  })

  DATA[:Ship][new_ship[:id]] = new_ship
  DATA[:Faction][faction_id].ships << new_ship.id
  new_ship
end

def get_ship(id)
  DATA[:Ship][id]
end

def get_faction(id)
  DATA[:Faction][id]
end

def get_rebels
  REBELS
end

def get_empire
  EMPIRE
end