class PassengerTrain < Train
  include InstanceCounter

  attr_reader :type

  def initialize(number)
    super(number, TYPE_PASSENGER)
  end
end
