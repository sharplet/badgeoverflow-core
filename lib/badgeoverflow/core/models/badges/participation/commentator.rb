require_relative '../badge'

class StackOverflow::Commentator < StackOverflow::Badge
  def series
    :commentator
  end
end

class StackOverflow::Pundit < StackOverflow::Commentator
end
