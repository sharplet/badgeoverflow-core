require 'yaml'

class BadgeOverflowConfig
  attr_reader :config_file

  def self.instance
    @@instance ||= new('config/badgeoverflow.yml')
  end

  def self.user_id
    instance.user_id
  end

  def self.site
    instance.site
  end

  def self.api_key
    instance.api_key
  end

  def initialize(config_file)
    @config_file = config_file
  end

  def user_id
    @user_id ||= config['user_id']
    @user_id ||= random_user
  end

  def site
    @site ||= config['site']
  end

  def api_key
    @api_key ||= config['api_key']
  end

  private

  def random_user
    config['users'].sample['id']
  end

  def config
    @@config ||= YAML.load(File.read(config_file))
  end
end
