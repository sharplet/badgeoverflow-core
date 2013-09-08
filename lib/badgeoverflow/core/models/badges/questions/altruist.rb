require_relative '../badge'

class Altruist < Badge

  def calculate_progress!
    self.progress_description = "Manually award a bounty on another person's question"
  end

end
