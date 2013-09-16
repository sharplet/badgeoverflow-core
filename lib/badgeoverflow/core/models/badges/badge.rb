require 'sanitize'
require 'cgi'

class Badge
  include Comparable
  RANK_INDEX = { "bronze" => 0, "silver" => 1, "gold" => 2 }

  attr_reader :badge_id, :user_id, :name, :description, :rank, :award_count, :badge_type, :link
  attr_reader :series, :order, :service
  attr_accessor :progress_description

  def initialize(badge_json, user_id)
    @data = badge_json
    @user_id = user_id
  end

  def <=>(other_badge)
    if other_badge.kind_of? Badge
      rank_comparison = RANK_INDEX[self.rank] <=> RANK_INDEX[other_badge.rank]

      if rank_comparison == 0
        self.order <=> other_badge.order
      else
        rank_comparison
      end
    end
  end

  def order
    0
  end

  def eql?(other_badge)
    self.badge_id == other_badge.badge_id &&
    self.name == other_badge.name &&
    self.rank == other_badge.rank &&
    self.user_id == other_badge.user_id
  end

  def hash
    self.badge_id.hash ^ self.name.hash ^ self.rank.hash ^ self.user_id.hash
  end

  def calculate_progress!
  end

  def progress_description
    @progress_description || description
  end

  def progress_title
    "Have you considered..."
  end

  def service
    @service ||= StackExchangeService.new('stackoverflow')
  end

  def badge_id;    @data['badge_id'];    end
  def name;        @data['name'];        end
  def rank;        @data['rank'];        end
  def award_count; @data['award_count']; end
  def badge_type;  @data['badge_type'];  end
  def link;        @data['link'];        end
  def description
    @description ||= Sanitize.clean(@data['description'])
  end

  class << self
    alias_method :orig_new, :new

    def new(badge_json, *args)
      badge_class = badge_class_from_name(badge_json['name'])

      if should_instantiate_subclass?(badge_class)
        badge_class.new(badge_json, *args)
      else
        orig_new(badge_json, *args)
      end
    end

    def first_badges_in_series(badge_array)
      first_badges_in_series = badge_array.reduce({}) do |series, badge|
        if badge.series
          first = series[badge.series]
          if !first || badge < first
            series[badge.series] = badge
          end
        else
          series[nil] ||= []
          series[nil] << badge
        end

        series
      end

      first_badges_in_series.values.flatten
    end

    private

    def badge_class_from_name(name)
      constant_name = constantise(name)

      if const_defined?(constant_name)
        badge_class = const_get(constant_name)

        if badge_class.ancestors.include?(Badge)
          badge_class
        end
      end
    end

    def should_instantiate_subclass?(subclass)
      subclass && self != subclass
    end

    def constantise(badge_name)
      badge_name = CGI.unescapeHTML(badge_name)
      badge_name.split(/[\W]/).map(&:capitalize).join
    end
  end
end
