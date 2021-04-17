class Train
  attr_reader :type, :route, :current_speed, :wagons, :number

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @current_speed = 0
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
    wagons << wagon if current_speed.zero? && wagon.type == type
  end
  
  def delete_wagon
    wagons.slice!(-1) if current_speed.zero? && wagons.count.positive?
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
  # Все методы ниже не должны быть доступны через клиентский код

  def previous_station
    route.stations[@station_index - 1] if @station_index.positive?
  end

  def current_station
    route.stations[@station_index]
  end

  def next_station
    route.stations[@station_index + 1] unless route.stations[@station_index] == route.stations.last
  end
end