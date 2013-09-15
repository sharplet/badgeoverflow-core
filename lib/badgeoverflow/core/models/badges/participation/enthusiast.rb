require_relative '../badge'

class Enthusiast < Badge
  def series
    :enthusiast
  end
end

class Fanatic < Enthusiast
end
