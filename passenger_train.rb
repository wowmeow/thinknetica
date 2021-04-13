class PassengerTrain < Train

  def add_wagon(passenger_wagon)
    wagons.add(passenger_wagon) if current_speed.zero? && passenger_wagon.instance_of?(PassengerWagon)
  end
end