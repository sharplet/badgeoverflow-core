require_relative '../badge'

class Custodian < Badge
  def series
    :custodian
  end
end

class Reviewer < Custodian
end

class Steward < Custodian
end
