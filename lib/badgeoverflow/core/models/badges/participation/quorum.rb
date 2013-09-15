require_relative '../badge'

class Quorum < Badge
  def series
    :quorum
  end
end

class Convention < Quorum
end
