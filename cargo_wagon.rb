require_relative 'wagon'

class CargoWagon < Wagon

  def initial(type = initial_type)
    super
  end

  def initial_type
    :cargo
  end
end
