require 'test_helper'

class LocationTest < ActiveSupport::TestCase
	test 'set and get' do
		loc = Location.new
		loc.latitude = 1.2
		loc.longitude = 2.1
		assert_equal(loc.latitude, 1.2)
  end

  test 'fetch locations' do
    locations = Location.fetch_locations
    assert locations > 0
  end

	test 'parse locations' do
		data = [[1,2], [3.7,4.9], [5,6]]
		locations = Location.parse_locations(data)
		assert_equal(locations.size, 3)
		assert_equal(locations['1-2'].latitude, 1)
		assert_equal(locations['1-2'].longitude, 2)
		assert_equal(locations['3.7-4.9'].latitude, 3.7)
		assert_equal(locations['3.7-4.9'].longitude, 4.9)
	end
end
