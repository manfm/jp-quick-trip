class TripController < ApplicationController
  def index
  end

  def send_favorite
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    email = params[:email]

    # prefectures = api.get_prefectures
    # prefectures should not change so often ;) and Api cache is not implemented yet therefore fixture from test is used
    prefectures = JSON.parse(File.read('test/odigo/prefectures_response.json'))['response']
    locator = AreaLocator.new(prefectures)

    begin
      # get prefecture from location
      prefecture = locator.locate lat, lng
      # get most popular trip in the prefecture
      trip = get_trip prefecture
      # send trip to email
      TripMailer.send_trip(trip, email).deliver_now

      render json: prefecture, status: 201
    rescue ArgumentError # Exception from locator.locale
      render json: 'Error: Location is outside japan', status: 406
    rescue TypeError, NoMethodError # parsing error caused by wrong Odigo API response
      render json: '3rd api error', status: 503
    end
  end

  def get_trip(prefecture)
    api = Api.new
    trip = api.get_most_popular_trip_for_city prefecture
    api.get_trip_detail trip['id']
  end
end
