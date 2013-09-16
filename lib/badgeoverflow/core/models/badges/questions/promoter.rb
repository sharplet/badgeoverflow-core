require_relative '../badge'

class StackOverflow::Promoter < StackOverflow::Badge

  def calculate_progress!
    self.progress_description = "Offer a bounty on your own question"
  end

end
