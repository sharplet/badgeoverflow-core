require_relative '../badge'

class CitizenPatrol < Badge
  def series
    :citizen_patrol
  end
end

class Deputy < CitizenPatrol
end

# class Marshal < CitizenPatrol
# end
