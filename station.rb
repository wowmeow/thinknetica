class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def trains_by_type(type)
    trains.count { |train| train.type == type }
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
