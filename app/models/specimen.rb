class Specimen

  require 'net/http'

  attr_accessor :latitude, :longitude, :length_in_mm, :species, :speciesExternalId, :thumbnail,:taxonUri
  
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
      specimen.speciesExternalId = dat[1]['data']['externalId']
      specimen.thumbnail = dat[1]['data']['thumbnailURL']
      fetch_taxonUri(specimen)
      # fetch_thumbnail(specimen)
      specimens << specimen
    end
    specimens
  end
  
  private 
  
  def self.fetch_taxonUri(specimen) 
    speciesExternalId = specimen.speciesExternalId
    if speciesExternalId
      if speciesExternalId.starts_with?("NCBI")
        speciesId = speciesExternalId.split(":")[1]
        specimen.taxonUri = "http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id="
        specimen.taxonUri << speciesId
      elsif speciesExternalId.start_with?("urn:lsid:marinespecies.org:taxname")
       speciesId = speciesExternalId.split(":")[4]
       specimen.taxonUri = "http://www.marinespecies.org/aphia.php?p=taxdetails&id="
       specimen.taxonUri << speciesId
     elsif speciesExternalId.start_with?("urn:lsid:itis.gov:itis_tsn")
      speciesId = speciesExternalId.split(":")[4]
      specimen.taxonUri = "http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value="
      specimen.taxonUri << speciesId
    end
  else
      #a wild guess
      specimen.taxonUri = "http://www.wikipedia.org/wiki/"
      specimen.taxonUri << specimen.species.split(" ")[0]
  end 
end

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
