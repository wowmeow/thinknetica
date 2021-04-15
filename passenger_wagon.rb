require_relative 'wagon'

class PassengerWagon < Wagon

  def initial(type = initial_type)
    super
  end


  def initial_type
    :passenger
  end

end

