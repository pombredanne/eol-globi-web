class PageController < ApplicationController

  include_class Java::org.trophic.graph.service.SpecimenServiceImpl
  include_class Java::org.trophic.graph.factory.SpecimenFactory

  def contact
  end

  def about
  end

  def home
      specimenService = SpecimenFactory.specimenService
      @specimens = specimenService.specimens
      @specimens
  end

  def terms
  end

  def signin
  end

  def signup
  end

end