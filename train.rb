class Train
  attr_reader :type, :quantity_wagons, :route, :current_speed

  def initialize(number, type, quantity_wagons)
    @number = number
    @type = type
    @quantity_wagons = quantity_wagons
    @current_speed = 0
  end

  def increase_speed(speed)
    @current_speed += speed
  end

  def stop_train
    @current_speed = 0 if @current_speed.positive?
  end


  def add_wagon
    @quantity_wagons += 1 if current_speed.zero?
  end

  def remove_wagon
    @quantity_wagons -= 1 if current_speed.zero? && quantity_wagons.positive?
  end

  def define_route(route)
    @route = route
    # @current_station = route.first_station
    @station_index = 0
    current_station.get_train(self)
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

