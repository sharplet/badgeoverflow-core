require_relative '../badge'

class StackOverflow::Caucus < StackOverflow::Badge
  def series
    :caucus
  end
end

class StackOverflow::Constituent < StackOverflow::Caucus
end
