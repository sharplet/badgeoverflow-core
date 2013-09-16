require_relative '../badge'

class StackOverflow::Talkative < StackOverflow::Badge
  def series
    :talkative
  end
end

class StackOverflow::Outspoken < StackOverflow::Talkative
end
