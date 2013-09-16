require_relative '../badge'

class StackOverflow::Benefactor < StackOverflow::Badge

  def calculate_progress!
    self.progress_description = "Manually award a bounty on your own question"
  end

end
