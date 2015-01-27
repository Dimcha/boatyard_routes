class Route
  attr_reader :start, :destination, :connection

  def initialize(start = nil, destination = nil, distance = 0)
    @start = start
    @destination = destination
    @distance = distance
    @connection = Connection.new
  end

  def stops
    @connection.stops + 1
  end

  def distance
    @distance + @connection.distance
  end

  def connect(route)
    @connection = route

    self
  end

  def create_connection(suburbs)
    bond = destination.route(suburbs)

    return NO_ROUTE if bond == NO_ROUTE

    connect(bond)
  end
end
