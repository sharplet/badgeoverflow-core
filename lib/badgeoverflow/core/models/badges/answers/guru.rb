require_relative '../badge'

class StackOverflow::Guru < StackOverflow::Badge

  def progress_title
    "You're getting close to..."
  end

  def calculate_progress!
    answers = service.fetch('users', 'answers', {
      ids: user_id,
      sort: 'votes',
      order: 'desc',
      filter: '!9cC8zqAGM',
      fetch_all_pages: true
    })

    highest_accepted_answer = answers.find { |answer| answer['is_accepted'] }

    if highest_accepted_answer
      question = service.fetch('questions', ids: highest_accepted_answer['question_id']).first
      title = question['title']
      link = highest_accepted_answer['link']
      score = highest_accepted_answer['score']
      remaining = required_score - score

      score_str = "#{score} " + "vote".pluralize(score, "votes")
      remaining_str = "#{remaining} " + "vote".pluralize(remaining, "votes")

      self.progress_description = "Your accepted answer to \"#{title.truncate(55).link_to(link)}\" has #{score_str}. #{remaining_str} to go!"
    else
      self.progress_description = "Accepted answer and score of #{required_votes} or more. You have not answered any questions yet!"
    end
  end

  def required_score
    40
  end

  def service
    @service ||= StackExchangeService.new
  end
end
