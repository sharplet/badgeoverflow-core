require_relative '../badge'

class StackOverflow::Suffrage < StackOverflow::Badge
  def series
    :suffrage
  end
end

class StackOverflow::VoxPopuli < StackOverflow::Suffrage
  def order
    1
  end
end
