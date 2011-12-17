class Specimen

  java_import 'org.trophic.graph.service.SpecimenServiceImpl'
  java_import 'org.trophic.graph.factory.SpecimenFactory'
  
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
      species = specimen.species.split(" ");      
      sp = RDFS::Resource.new("http://dbpedia.org/resource/#{species[0]}")
      specimen.thumbnail = sp.dbpedia::thumbnail.uri      
    rescue
      p "no thumbnail for #{species[0]}"
    end
  
end
