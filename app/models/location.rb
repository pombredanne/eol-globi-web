class Location

  require 'net/http'

  attr_accessor :latitude, :longitude, :altitude, :loc_count
  
  def self.fetch_locations
    query = "START location=node:locations('*:*') 
             RETURN location.latitude, location.longitude"
    uri = URI(Settings.neo4j_service)
    response = Net::HTTP.post_form(uri, 'query' => query)
    body = JSON.parse response.body
    parse_locations(body['data'])
  end

  def self.parse_locations(data)
    locations_map = Hash.new
    data.each { |lat, lon| 
      location = Location.new 
      location.latitude = lat
      location.longitude = lon
      location.loc_count = 1
      latlon = "#{location.latitude}-#{location.longitude}"
      if locations_map[latlon]
        loc = locations_map[latlon]
        loc.loc_count = loc.loc_count + 1;
      else 
        locations_map[latlon] = location
      end
    }
    locations_map
  end
  
  private 
  
  def fetch_thumbnail(specimen)
    species = specimen.species  
    sp = RDFS::Resource.new("http://dbpedia.org/resource/#{species}")
    specimen.thumbnail = sp.dbpedia::thumbnail.uri      
  rescue
    fetch_thumbnail_second_try(specimen)
  end

  def fetch_thumbnail_second_try(specimen)
    species = specimen.species.split(" ");      
    if (!@@no_image_available.include?(species[0]))
      sp = RDFS::Resource.new("http://dbpedia.org/resource/#{species[0]}")
      specimen.thumbnail = sp.dbpedia::thumbnail.uri
    end      
  rescue
    species = specimen.species.split(" ");      
    @@no_image_available.push species[0]
    p "no thumbnail for #{species[0]}"
  end
  
end