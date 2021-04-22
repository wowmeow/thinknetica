require_relative '../modules/manufacturer'

TYPE_PASSENGER = :passenger
TYPE_CARGO = :cargo

class Wagon
  include Manufacturer

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  protected
  def validate!
    reise "Type can't be empty!" if type.nil?
    reise "Type mast be 'passenger' or 'cargo'" if type != TYPE_PASSENGER || TYPE_CARGO
  end
end
