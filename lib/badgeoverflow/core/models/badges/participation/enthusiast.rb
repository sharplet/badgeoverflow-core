require_relative '../badge'

class StackOverflow::Enthusiast < StackOverflow::Badge
  def series
    :enthusiast
  end
end

class StackOverflow::Fanatic < StackOverflow::Enthusiast
end
