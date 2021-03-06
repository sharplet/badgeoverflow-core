require_relative '../badge'

class StackOverflow::NiceQuestion < StackOverflow::Badge
  def series
    :nice_question
  end

  def progress_title
    "You're getting close to..."
  end

  def calculate_progress!
    question = service.fetch('users', 'questions', {
      ids: user_id,
      sort: 'votes',
      order: 'desc',
      pagesize: 1,
      fetch_all_pages: false
    }).first

    title = question['title']
    link = question['link']
    score = question['score']
    remaining = required_score - score

    score_str = "#{score} " + "vote".pluralize(score, "votes")
    remaining_str = "#{remaining} " + "vote".pluralize(remaining, "votes")

    self.progress_description = "Your question \"#{title.truncate(75).link_to(link)}\" has #{score_str}. #{remaining_str} to go!"
  end

  def required_score
    10
  end
end

class StackOverflow::GoodQuestion < StackOverflow::NiceQuestion
  def required_score
    25
  end
end

class StackOverflow::GreatQuestion < StackOverflow::NiceQuestion
  def required_score
    100
  end
end
