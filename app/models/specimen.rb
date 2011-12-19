class Specimen

  java_import 'org.trophic.graph.service.SpecimenServiceImpl'
  java_import 'org.trophic.graph.factory.SpecimenFactory'
  
  @@no_image_available = ["Etropus"]
  
  def update_thumbnails
    specimenService = SpecimenFactory.specimenService
    @specimens = specimenService.allSpecimens
    @specimens.each do |specimen|
      fetch_thumbnail specimen
      specimenService.updateSpecimenWithThumbnail specimen
    end
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
