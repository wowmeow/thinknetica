require_relative 'modules/instance_counter'
require_relative 'modules/accessor'
require_relative 'modules/validation'

class Station
  include InstanceCounter
  include Validation
  extend Accessor

  STATION_NAME_FORMAT = /^[a-zа-я]{2,}/i.freeze
  @@all_stations = []

  attr_reader :name, :trains

  attr_accessor_with_history :example_with
  strong_attr_accessor :example, Symbol

  validate :name, :presence
  validate :name, :format, STATION_NAME_FORMAT

  def initialize(name)
    @name = name
    @trains = []
    validate!
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

  def all_trains_to(&block)
    @trains.count.positive? ? @trains.each(&block) : 0
  end

  def trains_by_type(type)
    @trains.count { |train| train.type == type }
  end

  private

  def get_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end
end