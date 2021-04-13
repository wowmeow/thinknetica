require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :type

  def initial
    @type = initial_type
  end

  def initial_type
    'cargo'
  end
end
