require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :seats_number, :occupied_seats_number

  def initialize(seats_number)
    super(initial_type)
    @seats_number = seats_number
    @occupied_seats_number = 0
  end

  def take_seat
    @occupied_seats_number += 1 if occupied_seats_number < seats_number
  end

  def empty_seats_number
    seats_number - occupied_seats_number
  end

  protected def validate!
    super
    raise 'Invalid wagon type!' if type != initial_type
  end

  private
  def initial_type
    :passenger
  end
end

