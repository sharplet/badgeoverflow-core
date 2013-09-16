require_relative '../badge'

class StackOverflow::Mortarboard < StackOverflow::Badge
  def series
    :mortarboard
  end
end

class StackOverflow::Epic < StackOverflow::Mortarboard
end

class StackOverflow::Legendary < StackOverflow::Mortarboard
end
