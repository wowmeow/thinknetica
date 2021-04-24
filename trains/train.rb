require_relative '../modules/instance_counter'
require_relative '../modules/manufacturer'

class Train
  include InstanceCounter
  include Manufacturer

  TRAIN_NUMBER_FORMAT = /^[0-9a-zа-я]{3}-*[0-9a-zа-я]{2}$/i.freeze

  @@all_trains = {}

  attr_reader :type, :route, :current_speed, :wagons, :number

  def initialize(number, type)
    @number = number
    @type = type
    validate!
    @wagons = []
    @current_speed = 0
    add_to_all_instance(number)
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def all_wagons_to(&block)
    @wagons.each(&block)
  end

  def add_to_all_instance(number)
    @@all_trains[number.to_sym] = self
  end

  def self.find_by_number(number)
    @@all_trains[number]
  end

  def increase_speed(speed)
    @current_speed += speed
  end

  def stop_train
    @current_speed = 0 if @current_speed.positive?
  end

  def define_route(route)
    @route = route
    @station_index = 0
    current_station = route.first_station
    current_station.get_train(self)
  end

  def add_wagon(wagon)
    wagon.type
  end
  
  def delete_wagon
    @wagons.slice!(-1) if current_speed.zero? && @wagons.count.positive?
  end

  def move_forward
    return unless next_station

    current_station.send_train(self)
    @station_index += 1
    current_station.get_train(self)
    current_station
  end

  def move_back
    if @station_index.positive?
      current_station.send_train(self)
      @station_index += 1
      current_station.get_train(self)
      current_station
    end
  end

  protected

  def validate!
    raise 'Train number has invalid format!' if number !~ TRAIN_NUMBER_FORMAT
    raise "Type can't be nil or empty!" if type.nil? || type.size.zero?
  end

  def previous_station
    @route.stations[@station_index - 1] if @station_index.positive?
  end

  def current_station
    @route.stations[@station_index]
  end

  def next_station
    @route.stations[@station_index + 1] unless @route.stations[@station_index] == @route.stations.last
  end
end