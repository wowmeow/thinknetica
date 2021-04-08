class Route
  attr_accessor :first_station, :last_station, :transit_stations, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @transit_stations = []
    @stations = [@first_station, @transit_stations, @last_station].flatten
  end

  def add_transit_station(station)
    stations.insert(-2, station)
  end

  def delete_transit_station(station)
    stations.delete(station)
  end

  def show_route
    puts first_station
    transit_stations.each { |station| puts station }
    puts last_station
  end
end
