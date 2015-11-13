require 'test_helper'

class ApiTest < ActiveSupport::TestCase
  test "trips" do
    # stub response - override get method - comment to connect to real server
    def Api.get(url)
      JSON.parse(File.read('test/odigo/trips_response.json'))
    end

    api = Api.new
    trip = api.get_most_popular_trip_for_city 'Aomori'
    assert_equal '553609ab69702d4edfcc0700', trip['id']
  end

  test "trip detail" do
    # stub response - override get method - comment to connect to real server
    def Api.get(url)
      JSON.parse(File.read('test/odigo/trip_response.json'))
    end

    api = Api.new
    trip = api.get_trip_detail '553609ab69702d4edfcc0700'
    assert_equal 'Yoyogi Park', trip['days'].first['spots'].first['name_en']
  end

  test "prefectures" do
    # stub response - override get method - comment to connect to real server
    def Api.get(url)
      JSON.parse(File.read('test/odigo/prefectures_response.json'))
    end

    api = Api.new
    prefecture = api.get_prefectures.first
    assert_equal 'Ibaraki', prefecture['name']
    assert_equal 36.9376863490587, prefecture['ne']['lat']
    assert_equal 140.78821685791013, prefecture['ne']['lng']
  end
end
