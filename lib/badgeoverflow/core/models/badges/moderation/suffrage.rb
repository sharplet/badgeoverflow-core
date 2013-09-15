# Note: Both these badges are bronze, what happens with the first_badges_in_series filter?

require_relative '../badge'

class Suffrage < Badge
  def series
    :suffrage
  end
end

class VoxPopuli < Suffrage
end
