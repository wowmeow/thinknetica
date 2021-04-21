class Interface
  attr_reader :stations, :routes, :trains

  MENU_EXIT = 'exit'.freeze

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def start
    loop do
      menu
      break if MENU_EXIT
    end
  end

  def menu
    menu_points
    user_input = gets.chomp.to_i
    case user_input
    when 0 then MENU_EXIT
    when 1 then create_station
    when 2 then add_train
    when 3 then create_route
    when 4 then manage_route
    when 5 then assign_train_route
    when 6 then add_wagon_to_train
    when 7 then delete_wagon_from_train
    when 8 then move_train
    when 9 then view_stations_list
    when 10 then view_trains_list_on_station
    else 'Некорректное значение!'
    end
  end

  private
  def menu_points
    puts"    0 - Выйти из меню
    1 - Создать новую станцию
    2 - Создать новый поезд
    3 - Создать новый маршрут
    4 - Добавить/удалить промежуточную станцию
    5 - Назначить маршрут поезду
    6 - Добавлять вагоны к поезду
    7 - Отцеплять вагоны от поезда
    8 - Перемещать поезд по маршруту вперед и назад
    9 - Просматривать список станций
    10 - Просмотреть список поездов на станции
    \nВведите номер из меню:"
  end

  def add_station(name_station)
    stations << Station.new(name_station)
  end

  def add_passenger_train(number_train)
    trains << PassengerTrain.new(number_train)
  end

  def add_cargo_train(number_train)
    trains << CargoTrain.new(number_train)
  end

  def add_route(first_station, last_station)
    routes << Route.new(first_station, last_station)
  end

  def create_station
    puts 'Введите название станции:'
    name_station = gets.chomp
    add_station(name_station)
  end

  def add_train
    puts 'Введите номер поезда:'
    number_train = gets.chomp
    puts 'Введите тип поезда по номеру:
            1 - пассажирский
            2 - грузовой'
    case gets.chomp
    when '1' then add_passenger_train(number_train)
    when '2' then add_cargo_train(number_train)
    else 'Некорректное значение'
    end
  end

  def create_route
    view_stations_list
    puts 'Введите индекс начальной станции:'
    first_station_index = gets.chomp.to_i
    first_station = stations.fetch(first_station_index)
    puts 'Введите индекс конечной станции:'
    last_station__index = gets.chomp.to_i
    last_station = stations.fetch(last_station__index)
    add_route(first_station, last_station)
  end

  def manage_route
    puts "\nВведите номер действия:
            1 - добавить станцию
            2 - удалить станцию"
    case gets.chomp
    when '1'
      add_station_to_route
    when '2'
      delete_station_from_route
    else 'Некорректное значение!'
    end
  end

  def add_station_to_route
    route = find_route_by_index
    view_stations_list
    puts 'Введите индекс станции для ее добавления в маршрут:'
    transit_station_index = gets.chomp.to_i
    transit_station = stations.fetch(transit_station_index)
    route.add_transit_station(transit_station)
    puts 'Маршрут изменен'
  end

  def delete_station_from_route
    route = find_route_by_index
    view_stations_list
    puts 'Введите название станции в этом маршруте для ее удаления:'
    transit_station = gets.chomp
    if route.stations.each { |station| station.name == transit_station }
      route.delete_transit_station(transit_station)
      puts 'Маршрут изменен'
    else 'Не удалось удалить станцию'
    end
  end

  def assign_train_route
    view_trains_list
    puts 'Введите номер поезда'
    number_train = gets.chomp
    train = trains.find { |train| train.number == number_train }

    view_routs_list
    puts 'Введите индекс маршрута:'
    route_index = gets.chomp.to_i
    route = routes.fetch(route_index)
    train.define_route(route)
  end

  def add_wagon_to_train
    train = find_train
    case train.type
    when :passenger
      train.add_wagon(PassengerWagon.new)
    when :cargo
      train.add_wagon(CargoWagon.new)
    else 'Не удалось прицепить вагон'
    end
  end

  def delete_wagon_from_train
    train = find_train
    train.delete_wagon
  end

  def move_train
    train = find_train
    puts 'Введите номер действия:
            1 - переместить поед вперед
            2 - переместить поезд назад'
    case gets.chomp
    when '1' then train.move_forward
    when '2' then train.move_back
    else 'Некорректное значение!'
    end
  end

  def view_trains_list
    trains.each { |train| puts "#{train.number}, тип: #{train.type}" }
  end

  def view_stations_list
    puts 'Список имеющихся станций:'
    stations.each_with_index { |station, index| puts "#{index}. #{station.name}" }
  end

  def view_trains_list_on_station
    view_stations_list
    puts 'Введите индекс станции для просмотра поездов на ней:'
    station_index = gets.chomp.to_i
    puts 'Список имеющихся поездов на станции:'
    stations.fetch(station_index).trains { |train| print "#{train}, " }
  end

  def view_routs_list
    puts 'Список имеющихся маршрутов:'
    if routes.count.positive?
      routes.each_with_index { |route, index| puts "#{index}. #{route.stations}" }
    else 'Маршрутов нет'
    end
  end

  def find_route_by_stations
    puts 'Введите первую станцию:'
    first_station = gets.chomp
    puts 'Введите последнюю  станцию:'
    last_station = gets.chomp
    route = routes.find { |route| route.first_station == first_station && route.last_station == last_station }
    puts "Выбранный маршрут: #{route.stations}"
  end

  def find_route_by_index
    view_routs_list
    puts 'Введите индекс маршрута:'
    route_index = gets.chomp.to_i
    route = routes.fetch(route_index)
    puts "Выбранный маршрут: #{route.stations}"
    route
  end

  def find_train
    view_trains_list
    puts 'Введите номер поезда'
    train_number = gets.chomp
    Train.find_by_number(train_number)
  end
end
