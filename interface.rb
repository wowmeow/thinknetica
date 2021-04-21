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
    when '4' then manage_route
    when '5' then assign_train_route
    when '6' then add_wagon_to_train
    when '7' then delete_wagon_from_train
    when '8' then move_train
    when '9' then view_stations_list
    when '10' then view_trains_list_on_station
    else 'Некорректное значение!'
    end
  end

  def menu_points
    puts "\n    0 - Выйти из меню
    1 - Создать новую станцию
    2 - Создать новый поезд
    3 - Создать новый маршрут
    4 - Добавить/удалить промежуточную станцию
    5 - Назначить маршрут поезду
    6 - Добавить вагон к поезду
    7 - Отцепить вагон от поезда
    8 - Переместить поезд по маршруту вперед/назад
    9 - Просмотреть список станций
    10 - Просмотреть список поездов на станции
    \nВведите номер из меню:"
  end

  def create_station
    begin
      puts 'Введите название станции (минимум 2 буквы):'
      name_station = gets.chomp
      stations << Station.new(name_station)
      rescue RuntimeError
        puts 'Некорректное название станции!'
        retry
    end
    puts "Станция #{name_station} успешно создана."
  end

  def create_train
    begin
      puts 'Введите тип поезда по номеру:
            1 - пассажирский
            2 - грузовой'
      type = gets.chomp
      raise ArgumentExeption if type != 1 || 2
    rescue ArgumentExeption
      puts 'Некорректное значение!'
      retry
    end
    begin
      puts "Введите номер поезда в формате '___-__' или '_____':"
      number_train = gets.chomp
      trains << (user_input == '1' ? PassengerTrain.new(number_train) : CargoTrain.new(number_train))
    rescue
      puts "Номер поезда не соответствует заданному формату!"
      retry
    end
    
    type = user_input == '1' ? 'пассажирского' : 'грузового'
    puts "Поезд с номером #{number_train} #{type} типа успешно создан."
  end

  def create_route
    view_stations_list
    
    begin
      puts 'Введите индекс начальной станции:'
      first_station_index = gets.chomp.to_i
      raise ArgumentExeption if first_station_index < 0 && first_station_index > stations.count
    rescue ArgumentExeption
      puts 'Такого индекса нет!'
      retry
    end
    first_station = stations.fetch(first_station_index)
    
    begin
      puts 'Введите индекс конечной станции:'
      last_station__index = gets.chomp.to_i 
      raise ArgumentExeption if first_station_index < 0 && first_station_index > stations.count
    rescue ArgumentExeption
      puts 'Такого индекса нет!'
      retry
    end
    
    last_station = stations.fetch(last_station__index)
    routes << Route.new(first_station, last_station)
  end

  def manage_route
    begin
      puts "\nВведите номер действия:
            1 - добавить станцию
            2 - удалить станцию"
    user_input = gets.chomp
    raise ArgumentExeption if user_input != 1 || 2
    rescue ArgumentExeption
      puts 'Такого номера нет'
      retry
    end
    user_input == '1' ? add_station_to_route : delete_station_from_route
  end

  def add_station_to_route
    route = find_route_by_index
    view_stations_list
    begin
      puts 'Введите индекс станции для ее добавления в маршрут:'
      transit_station_index = gets.chomp.to_i
      raise ArgumentExeption if transit_station_index < 0 && transit_station_index > stations.count
      rescue ArgumentExeption
        puts 'Такого индекса нет!'
        retry
    end
    transit_station = stations.fetch(transit_station_index)
    route.add_transit_station(transit_station)
    puts 'Маршрут изменен'
  end

  def delete_station_from_route
    route = find_route_by_index
    view_stations_list
    begin
      puts 'Введите название станции в этом маршруте для ее удаления:'
      transit_station = gets.chomp
      raise ArgumentExeption if route.stations.each { |station| station.name == transit_station }
    rescue ArgumentExeption
      puts 'Такой станции в маршруте нет!'
      retry
    end
    route.delete_transit_station(transit_station)
    puts 'Маршрут изменен'
  end

  def assign_train_route
    view_trains_list
    begin
    puts 'Введите номер поезда'
    number_train = gets.chomp
    train = trains.find { |train| train.number == number_train }
    end

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


  public

  # used for testing
  def seed
    puts Station.all
       puts Station.instances
       msc = Station.new('msc')
       puts "St_count: #{Station.instances}"
       puts '----------------------------------------------------------------------'
       puts "Traincount: #{Train.instances}"
       puts "PassengerTrain count: #{PassengerTrain.instances}"
       puts "CargoTrain count: #{CargoTrain.instances}"

       try02 = Train.new('try02', :cargo)
       try01 = Train.new('try01', :passenger)

       try03 = PassengerTrain.new('try-03')
       try04 = PassengerTrain.new('try04')
       try05 = CargoTrain.new('try-05')


       # ct1.add_wagon(Wagon.new(:cargo))
       # ct1.add_wagon(Wagon.new(:cargo))
       # try01.add_wagon(Wagon.new(:passenger))
       # try01.add_wagon(Wagon.new(:passenger))
       # try01.add_wagon(Wagon.new(:passenger))
       # pt1.add_wagon(Wagon.new(:passenger))
       # puts '- - - - - -'
       # puts "try01: #{Train.find_by_number('try01')}"
       # puts "pt2: #{PassengerTrain.find_by_number('pt2')}"
       # puts "Tr_count: #{Train.instances}"
       # puts "PassTr_count: #{PassengerTrain.instances}"
       # puts "CargoTr_count: #{CargoTrain.instances}"
  end
end


