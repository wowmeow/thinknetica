require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(type = initial_type)
    super
  end

  def initial_type
    :cargo
  end
end

