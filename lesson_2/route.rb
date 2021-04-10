class Route
  attr_accessor :first_station, :last_station, :transit_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @transit_stations = []
  end

  def add_transit_station(station)
    stations.insert(-2, station)
  end

  def delete_transit_station(station)
    stations.delete(station)
  end

  def stations
    [@first_station, @transit_stations, @last_station].flatten
  end
end
