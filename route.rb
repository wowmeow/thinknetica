require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Route
  include InstanceCounter
  include Validation

  attr_accessor :first_station, :last_station, :transit_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    validate!
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
    transit_stations << station
  end

  def delete_transit_station(station)
    stations.delete(station)
  end

  def stations
    [@first_station, @transit_stations, @last_station].flatten
  end
end
