require_relative '../on'

class CargoWagon < Wagon
  def initialize(type = initial_type)
    super
  end

  def initial_type
    :cargo
  end
end
