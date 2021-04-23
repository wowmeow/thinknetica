class PassengerTrain < Train
  include InstanceCounter

  attr_reader :type
  TYPE_PASSENGER = :passenger
  TYPE_CARGO = :cargo

  def initialize(number, seats_number)
    super(number, initial_type)
    @seats_number = seats_number
  end

  private
  def initial_type
    :passenger
  end
end
