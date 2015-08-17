

xwing = {id: '1', name: 'X-Wing'}
ywing = {id: '2', name: 'Y-Wing'}
awing = {id: '3', name: 'A-Wing'}
falcon = {id: '4', name: 'Millenium Falcon'}
home_one = {id: '5', name: 'Home One'}

tie_fighter = {id: '6', name: 'TIE Fighter'}
tie_interceptor = {id: '7', name: 'TIE Interceptor'}
executor = {id: '8', name: 'Executor'}

rebels = {
    id: '1',
    name: 'Alliance to Restore the Republic',
    ships: %w{1 2 3 4 5}
}

empire = {
    id: '2',
    name: 'Galactic Empire',
    ships: %w{6 7 8}
}

data = {
    Faction: {
        '1' => rebels,
        '2' => empire
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

next_ship = 9

def create_ship(ship_name, faction_id)
  new_ship = {
      id: (next_ship++).to_s,
      name: ship_name
  }
  data[:Ship][new_ship[:id]] = new_ship
  data[:Faction][faction_id].ships << new_ship.id
  new_ship
end

def get_ship(id)
  data[:Ship][id]
end

def get_faction(id)
  data[:Faction][id]
end

def get_rebels
  rebels
end

def get_empire
  empire
end