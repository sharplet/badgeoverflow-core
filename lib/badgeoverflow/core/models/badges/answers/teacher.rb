require_relative '../badge'

class Teacher < Badge

  def calculate_progress!
    answer = service.fetch('users', 'answers', {
      ids: user_id,
      sort: 'votes',
      order: 'desc',
      fetch_all_pages: true
    }).first

    if answer
      self.progress_description = "Answered first question with score of 1 or more. None of your answers have any upvotes yet!"
    else
      self.progress_description = "Answered first question with score of 1 or more. You have not answered any questions yet!"
    end
  end

  def service
    @service ||= StackExchangeService.new('stackoverflow')
  end
end
