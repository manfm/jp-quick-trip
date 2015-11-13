require 'test_helper'

class AreaLocatorTest < ActiveSupport::TestCase
  test "locate - custom data" do
    locations = [
      {
        'name' => 'Tokyo',
        'sw' => { 'lat' => 35.53485870242751, 'lng' => 139.40217803009637 },
        'ne' => { 'lat' => 35.8844389548463, 'lng' => 140.06135771759637 }
      },
      {
        'name' => 'Ibaraki',
        'sw' => { 'lat' => 35.945637273442976, 'lng' => 139.94776275634763 },
        'ne' => { 'lat' => 36.9376863490587, 'lng' => 140.78821685791013 }
      }
    ]

    locator = AreaLocator.new(locations)

    assert_equal 'Tokyo', locator.locate(35.54, 140)
    assert_equal 'Ibaraki', locator.locate(36, 140)

    # location does not exists
    assert_raises ArgumentError do
      locator.locate(36, 1)
    end
  end

  test "locate - integartion with api" do
    # api response
    locations = JSON.parse(File.read('test/odigo/prefectures_response.json'))['response']

    locator = AreaLocator.new(locations)

    assert_equal 'Tokyo', locator.locate(35.54, 140)
    assert_equal 'Ibaraki', locator.locate(36, 140)
    assert_equal 'Kanagawa', locator.locate(35.501982399999996, 139.4460327)

    # location does not exists
    assert_raises ArgumentError do
      locator.locate(36, 1)
    end
  end
end
