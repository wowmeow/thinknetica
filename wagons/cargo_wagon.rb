require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    super(initial_type)
    @total_volume = total_volume
    @occupied_volume = 0
  end

  def fill(volume)
    @occupied_volume += volume if occupied_volume + volume <= total_volume
  end

  def empty_volume
    total_volume - occupied_volume
  end

  protected def validate!
    super
    raise "Invalid wagon type!" if type != initial_type
  end

  private
  def initial_type
    :cargo
  end
end
