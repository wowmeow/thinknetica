require_relative 'modules/instance_counter'

class Route
  include InstanceCounter

  attr_accessor :first_station, :last_station, :transit_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    validate_first_and_last_station!
    @transit_stations = []
    register_instance
  end

  def valid?
    validate_first_and_last_station!
    true
  rescue StandardError
    false
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

  private
  def validate_first_and_last_station!
    raise "First station name can't be empty!" if first_station.nil?
    raise "Last station name can't be empty!" if last_station.nil?
    raise "First and last stations can't match!" if first_station == last_station
  end
end
