require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  STATION_NAME_FORMAT = /^[a-zа-я]{2,}/i.freeze
  @@all_stations = []

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def self.all
    @@all_stations
  end

  def trains_by_type(type)
    @trains.count { |train| train.type == type }
  end

  private
  def validate!
    raise "Station name can't be empty!" if name.nil?
    raise "Station name has invalid format!" if name !~ STATION_NAME_FORMAT
  end

  def get_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end
end
