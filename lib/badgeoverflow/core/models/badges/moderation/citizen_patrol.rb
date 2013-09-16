require_relative '../badge'

class StackOverflow::CitizenPatrol < StackOverflow::Badge
  def series
    :citizen_patrol
  end
end

class StackOverflow::Deputy < StackOverflow::CitizenPatrol
end

class StackOverflow::Marshal < StackOverflow::CitizenPatrol
end
