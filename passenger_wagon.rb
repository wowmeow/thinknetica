require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :type

  def initial
    @type = initial_type
  end

  private
  #
  def initial_type
    'passenger'
  end

end

