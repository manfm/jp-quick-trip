require 'test_helper'

class TripMailerTest < ActionMailer::TestCase
  test "send trip" do
    trip = JSON.parse(File.read('test/odigo/trip_response.json'))['response']
    user_email = 'my@email.com'

    email = TripMailer.send_trip(trip, user_email).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [user_email], email.to
    assert_equal "New trip 'Top Spots in Tokyo for Autumn Leaves'", email.subject
  end
end
