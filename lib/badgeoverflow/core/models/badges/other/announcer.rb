require_relative '../badge'

class Announcer < Badge
  def series
    :announcer
  end
end

class Booster < Announcer
end

class Publicist < Announcer
end
