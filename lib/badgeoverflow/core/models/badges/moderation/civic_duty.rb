require_relative '../badge'

class CivicDuty < Badge
  def series
    :civic_duty
  end

  def progress_title
    "You're getting close to..."
  end

  def calculate_progress!
    user = service.fetch('users', {
      ids: user_id,
      sort: 'reputation',
      order: 'desc',
      filter: '!--iqJa71*_pa',
      pagesize: 1,
      fetch_all_pages: false
    }).first

    vote_count = user['up_vote_count'] + user['down_vote_count']
    remaining = required_votes - vote_count

    remaining_str = "#{remaining} " + "vote".pluralize(remaining, "votes")

    self.progress_description = "#{description}. Only #{remaining_str} to go!"
  end

  def required_votes
    300
  end

  def service
    @service ||= StackExchangeService.new('stackoverflow')
  end
end

class Electorate < Badge
  def series
    :civic_duty
  end
end
