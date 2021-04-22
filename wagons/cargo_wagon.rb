require_relative 'wagon'

class CargoWagon < Wagon
  def initialize
    super(TYPE_CARGO)
  end

  protected def validate!
    super
    raise "Type mast be 'passenger' or 'cargo'" if type != TYPE_CARGO
  end
end
