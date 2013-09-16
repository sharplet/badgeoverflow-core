require_relative '../badge'

class StackOverflow::FavoriteQuestion < StackOverflow::Badge
  def series
    :favorite_question
  end

  def progress_title
    "You're getting close to..."
  end

  def calculate_progress!
    questions = service.fetch('users', 'questions', {
      ids: user_id,
      sort: 'votes',
      order: 'desc',
      filter: '!9cC8zbO*T',
      fetch_all_pages: true
    })

    # Get badge with highest favorite_count
    highest_favorites_question = questions.reduce do |highest_favorites, question|
      question['favorite_count'] > highest_favorites['favorite_count'] ? question : highest_favorites
    end

    if highest_favorites_question
      title = highest_favorites_question['title']
      link = highest_favorites_question['link']
      favorites = highest_favorites_question['favorite_count']
      remaining = required_favorites - favorites

      favorites_str = "#{favorites} " + "favorite".pluralize(favorites, "favorites")
      remaining_str = "#{remaining} " + "favorite".pluralize(remaining, "favorites")

      self.progress_description = "Your question \"#{title.truncate(70).link_to(link)}\" has #{favorites_str}. #{remaining_str} to go!"
    else
      self.progress_description = "Question favorited by #{required_favorites} users. You have not asked any questions yet!"
    end
  end

  def required_favorites
    25
  end

  def service
    @service ||= StackExchangeService.new('stackoverflow')
  end
end

class StackOverflow::StellarQuestion < StackOverflow::FavoriteQuestion
  def required_favorites
    100
  end
end
