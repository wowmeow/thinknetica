require_relative 'station'
require_relative 'route'
require_relative 'trains/train'
require_relative 'trains/cargo_train'
require_relative 'trains/passenger_train'
require_relative 'wagons/wagon'
require_relative 'wagons/cargo_wagon'
require_relative 'wagons/passenger_wagon'

class Interface
  attr_reader :stations, :routes, :trains

  MENU_EXIT = 'exit'.freeze

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @passenger_wagons = []
    @cargo_wagons = []
  end

  def start
    loop do
      menu
      break if menu == MENU_EXIT
    end
  end

  def menu
    menu_points
    user_input = gets.chomp
    case user_input
    when '0' then MENU_EXIT
    when '1' then create_station
    when '2' then create_train
    when '3' then create_route
    when '4' then create_wagon
    when '5' then manage_route
    when '6' then assign_train_route
    when '7' then add_wagon_to_train
    when '8' then delete_wagon_from_train
    when '9' then move_train
    when '10' then occupy_wagon
    when '11' then view_stations_list
    when '12' then view_trains_list_on_station
    when '13' then view_all_wagons_list
    when '14' then view_list_wagons_of_train
    when '15' then view_list_trains_at_station
    else 'Некорректное значение!'
    end
  end

  def menu_points
    puts "\n    0 - Выйти из меню
    1 - Создать новую станцию
    2 - Создать новый поезд
    3 - Создать новый маршрут
    4 - Создать новый вагон
    5 - Добавить/удалить промежуточную станцию
    6 - Назначить маршрут поезду
    7 - Добавить вагон к поезду
    8 - Отцепить вагон от поезда
    9 - Переместить поезд по маршруту вперед/назад
    10  - Занять место/объем в вагоне
    11 - Посмотреть список станций
    12 - Посмотреть список поездов на станции
    13 - Посмотреть список всех вагонов
    14 - Посмотреть список вагонов у поезда
    15 - Посмотреть список поездов на станции
    \nВведите номер из меню:"
  end

  def create_station
    begin
      puts 'Введите название станции (минимум 2 буквы):'
      name_station = gets.chomp
      @stations << Station.new(name_station)
    rescue RuntimeError
      puts 'Некорректное название станции!'
      retry
    end
    puts "Станция #{name_station} успешно создана."
  end

  def create_train
    user_input = choose_type
    begin
      puts "Введите номер поезда в формате '___-__' или '_____':"
      number_train = gets.chomp
      @trains << (user_input == 1 ? PassengerTrain.new(number_train) : CargoTrain.new(number_train))
    rescue RuntimeError
      puts 'Номер поезда не соответствует заданному формату!'
      retry
    end
    type = user_input == 1 ? 'пассажирского' : 'грузового'
    puts "Поезд с номером #{number_train} #{type} типа успешно создан."
  end

  def create_route
    puts "Начальная станция"
    first_station = find_station
    puts "Конечная станция"
    last_station = find_station
    @routes << Route.new(first_station, last_station)
    puts 'Маршрут создан'
  end

  def create_wagon
    type = choose_type
    case type
    when 1
      puts 'Введите количество пассажирских мест в вагоне:'
      seats_number = gets.chomp.to_i
      @passenger_wagons << PassengerWagon.new(seats_number)
    when 2
      puts 'Введите объем вагона:'
      total_volume = gets.chomp.to_i
      @cargo_wagons << CargoWagon.new(total_volume)
    end
    puts 'Вагон успешно создан'
  end

  def manage_route
    loop do
      puts "\nВведите номер действия:
            1 - добавить станцию
            2 - удалить станцию"
      user_input = gets.chomp
      break if [1, 2].include?(user_input)
    end
    user_input == '1' ? add_station_to_route : delete_station_from_route
  end

  def add_station_to_route
    route = find_route_by_index
    transit_station = find_station
    route.add_transit_station(transit_station)
    puts 'Маршрут изменен'
  end

  def delete_station_from_route
    route = find_route_by_index
    loop do
      puts 'Введите название станции в этом маршруте для ее удаления:'
      transit_station = find_station
      break unless route.stations.each { |station| station.name == transit_station }
    end
    route.delete_transit_station(transit_station)
    puts 'Маршрут изменен'
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
      wagon = find_passenger_wagon
      train.add_wagon(wagon)
    when :cargo
      wagon = find_cargo_wagon
      train.add_wagon(wagon)
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

  def occupy_wagon
    type = choose_type
    type == 2 ? occupy_passenger_wagon : occupy_cargo_wagon
  end

  def occupy_passenger_wagon
    wagon = find_passenger_wagon
    wagon.take_seat
    puts "Пустых мест осталось: #{wagon.empty_seats_number}"
  end

  def occupy_cargo_wagon
    wagon = find_cargo_wagon
    puts "Какой объем вагона заволнить?"
    volume = gets.chomp.to_i
    wagon.fill(volume)
    puts "Свободного места осталось: #{wagon.empty_volume}"
  end

  def view_trains_list
    puts "Список всех поездов:"
    trains.each { |train| puts "#{train.number}, тип: #{train.type}" }
  end

  def view_stations_list
    puts 'Список имеющихся станций:'
    stations.each { |station| puts station.name }
  end

  def view_trains_list_on_station
    station = find_station
    puts 'Список имеющихся поездов на станции:'
    station.all_trains_to(->(train) { puts "Поезд №#{train.number}, тип: #{train.type}" })
  end

  def view_routs_list
    puts 'Список имеющихся маршрутов:'
    if routes.count.positive?
      routes.each_with_index { |route, index| puts "#{index}. #{route.stations}" }
    else 'Маршрутов нет'
    end
  end

  def view_all_wagons_list
    view_passenger_wagons_list
    view_cargo_wagons_list
  end

  def view_passenger_wagons_list
    puts "\nСписок имеющихся пассажирских вагонов:"
    if @passenger_wagons.count.positive?
      @passenger_wagons.each_with_index { |wagon, index| puts "#{index}. Мест: #{wagon.seats_number}" }
    else 'Пассажирских вагонов нет'
    end
  end

  def view_cargo_wagons_list
    puts "\nСписок имеющихся грузовых вагонов:"
    if @cargo_wagons.count.positive?
      @cargo_wagons.each_with_index { |wagon, index| puts "#{index}. Общая вместимость: #{wagon.total_volume}" }
    else 'Пассажирских вагонов нет'
    end
  end

  def view_list_wagons_of_train
    puts "Список вагонов в поезде:"
    train = find_train
    case train.type
    when :passenger
      train.all_wagons_to(->(wagon) { puts "Вагон с количеством мест: #{wagon.seats_number}" })
    when :cargo
      train.all_wagons_to(->(wagon) { puts "Вагон с вместимостью: #{wagon.total_volume}" })
    else puts 'Что-то пошло не так'
    end
  end

  def view_list_trains_at_station
    puts "Список поездов на станции:"
    station = find_station
    station.all_trains_to(->(train) { puts "Поезд №#{train.number}, тип: #{train.type}" })
  end

  def find_station
    view_stations_list
    station = ''
    loop do
      puts 'Введите название станции:'
      name = gets.chomp
      station = @stations.detect { |station| station.name == name }
      station.nil? ? (puts 'Такой станции нет') : break
    end
    station
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

  def find_passenger_wagon
    view_passenger_wagons_list
    return unless @passenger_wagons.positive?

    puts 'Введите необходимую вместимость вагона:'
    seats_number = gets.chomp.to_i
    passenger_wagon = @passenger_wagons.detect { |wagon| wagon.seats_number == seats_number }
    passenger_wagon.nil? ? (puts 'Такого вагона нет') : passenger_wagon
  end

  def find_cargo_wagon
    view_cargo_wagons_list
    return unless @cargo_wagons.positive?

    puts 'Введите необходимую вместимость вагона:'
    volume = gets.chomp.to_i
    cargo_wagon = @cargo_wagons.detect { |wagon| wagon.total_volume == volume }
    cargo_wagon.nil? ? (puts 'Такого вагона нет') : cargo_wagon
  end

  def choose_type
    type = 0
    loop do
      puts 'Выберете тип по номеру:
            1 - пассажирский
            2 - грузовой'
      type = gets.chomp.to_i
      break if [1, 2].include?(type)
    end
    type
  end
end
