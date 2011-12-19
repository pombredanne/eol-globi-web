class PageController < ApplicationController

  java_import 'org.trophic.graph.service.SpecimenServiceImpl'
  java_import 'org.trophic.graph.factory.SpecimenFactory'

  def contact
  end

  def about
  end

  def home
    specimenService = SpecimenFactory.specimenService
    @specimens = specimenService.specimens
  end
  
  def location
    @lat = params[:lat]
    @lng = params[:lng]
    specimenService = SpecimenFactory.specimenService
    @specimens = specimenService.getSpecimensByLocation(@lat, @lng)
  end

  def terms
  end

  def signin
  end

  def signup
  end

end