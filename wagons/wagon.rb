require_relative '../modules/manufacturer'

class Wagon
  include Manufacturer

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  protected
  def validate!
    raise "Type can't be empty!" if type.nil?
  end
end
