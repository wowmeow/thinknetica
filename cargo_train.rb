class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super(number, wagons)
    @type = initial_type
  end

  def initial_type
    :cargo
  end
end
