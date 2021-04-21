require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize
    super(TYPE_PASSENGER)
  end

  protected def validate!
    super
    raise "Type mast be 'passenger' or 'cargo'" if type != TYPE_PASSENGER
  end
end

