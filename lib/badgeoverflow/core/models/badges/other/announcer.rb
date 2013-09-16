require_relative '../badge'

class StackOverflow::Announcer < StackOverflow::Badge
  def series
    :announcer
  end
end

class StackOverflow::Booster < StackOverflow::Announcer
end

class StackOverflow::Publicist < StackOverflow::Announcer
end
