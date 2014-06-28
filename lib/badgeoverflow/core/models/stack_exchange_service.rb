require 'net/http'
require 'json'
require 'badgeoverflow/core/config'

class StackExchangeService
  attr_reader :site, :api_version

  def initialize(site = nil, api_version = 2.2)
    @site = site || BadgeOverflowConfig.site || 'stackoverflow'
    @api_version = api_version
    @api_key = BadgeOverflowConfig.api_key
  end

  # Fetches 1 or more of a given resource.
  #
  # When the request completes, the 'items' key of the response is
  # yielded to the block.
  #
  # Params:
  # +primary_resource+::
  #   the stack exchange resource, e.g., "users", "badges/name"
  # +secondary_resource+::
  #   an optional nested resource, e.g., "users/1/badges"
  # +params+::
  #   an optional params hash; all passed through to the query
  #   string, except for the special param +:ids+ which is an
  #   array of ids passed into the URL path
  #
  def fetch(primary_resource, secondary_resource = nil, params = {}) # :yields: items
    if secondary_resource.kind_of? Hash
      params = secondary_resource
      secondary_resource = nil
    end

    page = 1
    items = []
    should_fetch_more = create_fetch_more_condition(params)

    loop do
      response = get(primary_resource, secondary_resource, params.merge(page: page))
      body = JSON.parse(response.body)

      handle_error_if_required(body)

      response_items = body['items']
      response_items ||= []
      items += response_items

      page += 1

      if fetch_more?(current: body, fetched: items, pred: should_fetch_more)
        backoff = body['backoff']
        if backoff
          sleep backoff
        end
      else
        break
      end
    end

    if block_given?
      yield items
    end

    items
  end

  private
  
  def fetch_more?(current: {}, fetched: [], pred: ->{ true })
    case pred.arity
    when 0
      pred.()
    when 1
      pred.(current)
    when 2
      pred.(current, fetched)
    else
      fail "invalid predicate"
    end
  end

  def create_fetch_more_condition(params)
    fetch_all_pages = params.delete(:fetch_all_pages)
    fetch_all_pages = true if fetch_all_pages.nil?
    limit = params.delete(:limit)

    ->(body) {
      fetch_all_pages && body['has_more']
    }
  end

  def get(primary_resource, secondary_resource, params = {})
    ids = *params.delete(:ids)

    path = "/#{api_version}/#{primary_resource}/"
    path << "#{ids.join(';')}/" unless ids.empty?
    path << "#{secondary_resource}/" if secondary_resource

    final_params = default_params.merge(params)

    stack_exchange.get("#{path}?#{param_string(final_params)}")
  end

  def handle_error_if_required(response_body)
    error_id = response_body['error_id']
    if error_id
      name = response_body['error_name']
      message = response_body['error_message']

      case name
      when "throttle_violation"
        seconds_remaining = message.gsub(/^.*?(\d+) seconds$/, '\1').to_i
        raise "Throttle violation! This will be lifted at #{Time.new + seconds_remaining}."
      else
        raise "#{name} (#{error_id}): #{message}"
      end
    end
  end

  def stack_exchange
    @stack_exchange ||= Net::HTTP.new('api.stackexchange.com')
  end

  def default_params
    @default_params ||= { site: site, pagesize: 30 }

    if @api_key
      @default_params[:key] = @api_key
    end
    @default_params
  end

  def param_string(params)
    params.map{|k,v| "#{k}=#{v}"}.join('&')
  end

end
