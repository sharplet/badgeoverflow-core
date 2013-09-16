require_relative '../badge'

class StackOverflow::Quorum < StackOverflow::Badge
  def series
    :quorum
  end
end

class StackOverflow::Convention < StackOverflow::Quorum
end
