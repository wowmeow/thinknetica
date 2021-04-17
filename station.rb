require_relative 'instance_counter'

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

  # Только сама станция принимает поезд
  def get_train(train)
    @trains << train
  end

  # Только сама станция позволяет поезду уехать
  def send_train(train)
    @trains.delete(train)
  end
end
