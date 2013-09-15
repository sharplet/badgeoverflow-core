require_relative '../badge'

class CivicDuty < Badge
  def series
    :civic_duty
  end
end

class Electorate < CivicDuty
end
