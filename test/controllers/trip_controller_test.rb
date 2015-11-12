require 'test_helper'

class TripControllerTest < ActionController::TestCase
  test 'get main index page' do
    get :index
    assert_response :success
    assert_select 'h1', 'Odigo quick trip in Japan'
  end
end
