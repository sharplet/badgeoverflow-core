require_relative '../badge'

class Mortarboard < Badge
  def series
    :mortarboard
  end
end

class Epic < Mortarboard
end

class Legendary < Mortarboard
end
