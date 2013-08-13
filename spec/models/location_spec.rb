require 'spec_helper'

describe Location do
  
  describe 'fetch_locations' do
    
    it 'fetches the location' do
      locations = Location.fetch_locations 
      locations.should_not be_nil
    end

  end
  
end