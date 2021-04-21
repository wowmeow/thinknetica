require_relative 'modules/instance_counter'

class Station
  include InstanceCounter
  attr_reader :name, :trains
  @@all_instances = []

  def initialize(name)
    @name = name
    @trains = []
    @@all_instances << self
    register_instance
  end

  def self.all
    @@all_instances
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
