require_relative '../modules/manufacturer'
require_relative '../modules/validation'

class Wagon
  include Manufacturer
  include Validation

  attr_reader :type

  def initialize(type)
    @type = type
  end

  protected

  def validate!
    raise "Type can't be empty!" if type.nil?
  end
end
