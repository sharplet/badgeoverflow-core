require_relative '../badge'

class Suffrage < Badge
  def series
    :suffrage
  end
end

class VoxPopuli < Suffrage
  def order
    1
  end
end
