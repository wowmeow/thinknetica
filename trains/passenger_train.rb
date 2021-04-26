class PassengerTrain < Train
  include InstanceCounter

  attr_reader :type

  def initialize(number)
    super(number, initial_type)
  end

  private

  def initial_type
    :passenger
  end
end
