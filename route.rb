require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_accessor :first_station, :last_station, :transit_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @transit_stations = []
    register_instance
  end

  def add_transit_station(station)
    self.transit_stations << station
  end

  def delete_transit_station(station)
    self.stations.delete(station)
  end

  def stations
    [@first_station, @transit_stations, @last_station].flatten
  end
end
