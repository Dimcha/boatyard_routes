class Suburb
  attr_reader :name

  def initialize(name)
    @name = name
    @destinations = {}
  end

  def route(suburbs = '')
    return Connection.new if suburbs.empty?

    destination = @destinations[suburbs[0]]

    return NO_ROUTE if destination.nil?

    connecting_suburbs = suburbs.slice(1, suburbs.length)
    create_route(destination).create_connection(connecting_suburbs)
  end

  def find_all_routes(final_stop, max_stops = 10 , stops = 0)
    routes = []

    return routes if stops == max_stops

    routes += direct_route(final_stop)
    routes += connecting_routes(final_stop, max_stops, stops)
  end

  def connecting_routes(final_stop, max_stops, stops)
    [].tap do |routes|
      @destinations.values.each do |destination|
        destination[:suburb].find_all_routes(final_stop, max_stops, stops + 1).each do |connection|
          routes << create_route(destination).connect(connection)
        end
      end
    end
  end

  def direct_route(final_stop)
    route = route(final_stop.name)
    route == NO_ROUTE ? [] : [route]
  end

  def add_destination(destination)
    @destinations[destination[:suburb].name] = destination
  end

  private

  def create_route(destination)
    Route.new(self, destination[:suburb], destination[:distance])
  end
end
