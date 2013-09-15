require_relative '../badge'

class Caucus < Badge
  def series
    :caucus
  end
end

class Constituent < Caucus
end
