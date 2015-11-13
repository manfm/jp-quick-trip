require 'test_helper'

class TripControllerTest < ActionController::TestCase
  def setup
    @payload = {lat: 35.501982399999996, lng: 139.4460327, email: 'my@email.com', format: :json}
  end

  test 'get main index page' do
    get :index
    assert_response :success
    assert_select 'h1', 'Odigo quick trip in Japan'
  end

  test 'send email with trip based on location in japan' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      trip = JSON.parse(File.read('test/odigo/trip_response.json'))['response']
      # Stubbing get_trip makes test independent on Api calls
      @controller.stub :get_trip, trip do
        post :send_favorite, @payload
      end
      assert_response 201
    end

    sent_email = ActionMailer::Base.deliveries.last
    assert_equal @payload[:email], sent_email.to[0]
  end

  test 'wrong location - outside of japan' do
    invalid_payload = @payload
    invalid_payload[:lng] = -1 # not in Japan

    post :send_favorite, invalid_payload
    assert_response 406
  end

  test 'fail api call' do
    # Stubbing Api.get simulates 3rd api call problem
    Api.stub :get, false do
      post :send_favorite, @payload
    end

    assert_response 503
  end
end
