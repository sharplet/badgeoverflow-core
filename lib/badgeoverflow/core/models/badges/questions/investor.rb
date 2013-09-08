require_relative '../badge'

class Investor < Badge

  def calculate_progress!
    self.progress_description = "Offer a bounty on another person's question"
  end

end
