require_relative '../badge'

class StackOverflow::Altruist < StackOverflow::Badge

  def calculate_progress!
    self.progress_description = "Manually award a bounty on another person's question"
  end

end
