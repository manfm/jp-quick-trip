require 'httparty'

class Api
  include HTTParty
  base_uri 'https://www.odigo.travel'
  default_timeout 3 # hard timeout after 1 second

  # *params*
  # * String city - probably prefecture name. It is not clear from the Api
  # *return*
  # * Hash - first trip for city
  def get_most_popular_trip_for_city(city)
    server_response = handle_timeouts do
      get "/1/trips.json?city=#{city}&locale=en&sort_by=popularity"
    end
    server_response['response'].first
  end

  # *params*
  # * String id - id of trip
  # *return*
  # * Hash - trip detail with places
  def get_trip_detail(id)
    server_response = handle_timeouts do
      get "/1/trips/#{id}.json?locale=en"
    end
    server_response['response']
  end

  # *return*
  # * List - prefectures - or cities. It is used as param for method get_most_popular_trip_for_city
  def get_prefectures
    server_response = handle_timeouts do
      get '/1/neighborhoods.json?locale=en'
    end
    server_response['response']
  end

  def get(url)
    self.class.get(url)
  end

  def handle_timeouts
    yield
  rescue Net::OpenTimeout, Net::ReadTimeout
    {}
  end
end
