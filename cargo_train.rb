class CargoTrain < Train

  def add_wagon(cargo_wagon)
    wagons.add(cargo_wagon) if current_speed.zero? && cargo_wagon.class.instance_of?(CargoWagon)
  end
end