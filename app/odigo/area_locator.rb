class AreaLocator
  # *params*
  # List locations - list of hashes {name : 'NewYork', sw: {lat: 1.1, lng: 1.1}, ne: {lat: 1.2, lng: 1.2}}
  def initialize(locations)
    @locations = locations
  end

  # *params*
  # * Float lat - latitude
  # * Float lng - longitude
  # *return*
  # * Object - name from hash with given position
  # *raise*
  # * ArgumentError
  def locate(lat, lng)
    location = nil
    @locations.each do |loc|
      in_lat = loc['sw']['lat'] <= lat && loc['ne']['lat'] >= lat
      in_lng = loc['sw']['lng'] <= lng && loc['ne']['lng'] >= lng

      if in_lat && in_lng
        location = loc['name']
        break
      end
    end
    fail ArgumentError, 'No location found' if location.nil?

    location
  end
end
