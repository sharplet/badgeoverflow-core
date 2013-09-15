require_relative '../badge'

class Commentator < Badge
  def series
    :commentator
  end
end

class Pundit < Commentator
end
