require_relative '../badge'

class StackOverflow::Excavator < StackOverflow::Badge
  def series
    :excavator
  end
end

class StackOverflow::Archaeologist < StackOverflow::Excavator
end
