class Routes
  def initialize(routes)
    @suburbs = {}

    routes.scan(/[a-zA-Z]{2}\d/) do |route|
      destination = { suburb: get_suburb(route[1]), distance: route[2..-1].to_i }
      get_suburb(route[0]).add_destination(destination)
    end
  end

  def get_suburb(name)
    @suburbs[name] ||= Suburb.new(name)
  end

  def find_route_distance(*suburbs)
    route = find_route(suburbs)

    return NO_ROUTE if route == NO_ROUTE

    route.distance
  end

  def find_route(suburbs)
    return NO_ROUTE if suburbs.size < 2

    get_suburb(suburbs[0]).route(suburbs.slice(1, suburbs.size))
  end

  def trips_with_max_stops(start, destination, stops = 10)
    first_suburb = get_suburb(start)
    last_suburb = get_suburb(destination)

    first_suburb.find_all_routes(last_suburb, stops)
  end

  def trips_with_stops(start, destination, stops)
    trips_with_max_stops(start, destination, stops).select do |route|
      route.stops == stops
    end
  end

  def distance_of_shortest_route(start, destination)
    trips_with_max_stops(start, destination).map(&:distance).min || NO_ROUTE
  end

  def trips_with_less_distance(start, destination, max_distance)
    trips_with_max_stops(start, destination).select { |route| route.distance < max_distance }
  end
end
