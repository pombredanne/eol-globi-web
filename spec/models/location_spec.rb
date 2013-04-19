require 'spec_helper'

describe Location do

  before(:each) do
    @location = Location.new({:latitude => "9999", :longitude => "4444"})
    @location.save
  end
  
  after(:each) do 
    @location.remove
  end
  
  describe "fetch_locations" do 
    
    it "fetches the location" do 
      locations = Location.fetch_locations 
      locations.should_not be_nil
    end

  end
  
end