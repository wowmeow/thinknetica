class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super(number, wagons)
    @type = initial_type
  end

  def initial_type
    :passenger
  end
end
