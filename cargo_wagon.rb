require_relative 'wagon'

class CargoWagon < Wagon

  def initial
    @type = initial_type
  end

  private
  # метод - констранта

  def initial_type
    :cargo
  end
end
