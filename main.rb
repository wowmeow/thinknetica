require_relative 'station'
require_relative 'route'
require_relative 'trains/train'
require_relative 'trains/cargo_train'
require_relative 'trains/passenger_train'
require_relative 'wagons/wagon'
require_relative 'wagons/cargo_wagon'
require_relative 'wagons/passenger_wagon'
require_relative 'interface'

Interface.new.start
