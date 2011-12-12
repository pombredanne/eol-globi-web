class PageController < ApplicationController

  java_import 'org.trophic.graph.service.SpecimenServiceImpl'
  java_import 'org.trophic.graph.factory.SpecimenFactory'
  
  @@excludes = ["Paralichthys", "Trichopsetta", "Coelorinchus"]

  def contact
  end

  def about
  end

  def home
    specimenService = SpecimenFactory.specimenService
    @specimens = specimenService.specimens
    p @specimens.length
  end
  
  def location
    @lat = params[:lat]
    @lng = params[:lng]
    specimenService = SpecimenFactory.specimenService
    @specimens = specimenService.getSpecimensByLocation(@lat, @lng)
    @specimens.each do |specimen|
      fetch_thumbnail specimen
    end
  end

  def terms
  end

  def signin
  end

  def signup
  end
  
  private 
  
    def fetch_thumbnail(specimen)
      species = specimen.species.split(" ");
      if (!@@excludes.include? species[0] )
        sp = RDFS::Resource.new("http://dbpedia.org/resource/#{species[0]}")
        specimen.thumbnail = sp.dbpedia::thumbnail.uri
      end       
    rescue
      @@excludes.push(species[0])
      p species[0]
    end

end