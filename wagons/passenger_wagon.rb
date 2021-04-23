require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :seats_number, :occupied_seats_number

  def initialize(seats_number = 0)
    super(initial_type)
    @seats_number = seats_number
    @occupied_seats_number = 0
    validate!
  end

  def take_seat
    @occupied_seats_number += 1 if occupied_seats_number < seats_number
  end

  def empty_seats_number
    seats_number - occupied_seats_number
  end

  protected def validate!
    raise "Type can't be empty!" if type.nil?
    raise 'Invalid wagon type!' if type != initial_type
    raise "Seats number can't be empty!" if seats_number.nil?
    raise "Seats number can't be negative!" if seats_number.negative?
    raise 'Seats number must be an integer!' unless Integer(seats_number)
  end

  private def initial_type
    :passenger
  end
end
