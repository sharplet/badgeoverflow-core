require_relative '../badge'

class Student < Badge

  def progress_title
    "You're getting close to..."
  end

  def calculate_progress!
    self.progress_description = "Asked first question with score of 1 or more. You could try improving an existing question, or asking more questions!"
  end

end
