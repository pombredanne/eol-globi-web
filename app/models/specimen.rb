class Specimen

  require 'net/http'

  attr_accessor :latitude, :longitude, :length_in_mm, :species, :thumbnail
  
  def self.fetch_specimens(lat, lon)
    p "lat: #{lat} lon: #{lon}"
    query = "START location=node:locations('*:*') 
             MATCH location<-[:COLLECTED_AT]-specimen-[:CLASSIFIED_AS]->species 
             WHERE location.latitude=#{lat} AND location.longitude=#{lon} RETURN specimen, species"
    uri = URI(Settings.neo4j_service)
    response = Net::HTTP.post_form(uri, 'query' => query)
    body = JSON.parse response.body
    specimens = Array.new
    body['data'].each do |dat| 
      specimen = Specimen.new 
      specimen.latitude = lat
      specimen.longitude = lon
      specimen.length_in_mm = dat[0]['data']['lengthInMm']
      specimen.species = dat[1]['data']['name']
      # fetch_thumbnail(specimen)
      specimens << specimen
    end
    specimens
  end
  
  private 
  
    def self.fetch_thumbnail(specimen)
      species = specimen.species  
      sp = RDFS::Resource.new("http://dbpedia.org/resource/#{species}")
      specimen.thumbnail = sp.dbpedia::thumbnail.uri
      p "#{specimen.thumbnail}"      
    rescue
      #fetch_thumbnail_second_try(specimen)
    end
    
    def self.fetch_thumbnail_second_try(specimen)
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
