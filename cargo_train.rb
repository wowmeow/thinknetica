class CargoTrain < Train
  include InstanceCounter

  attr_reader :type

  def initialize(number)
    super(number, wagons)
    @type = initial_type
    register_instance
  end

  def initial_type
    :cargo
  end
end
