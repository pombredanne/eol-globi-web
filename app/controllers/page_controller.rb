class PageController < ApplicationController

  include_class Java::org.trophic.graph.service.LocationServiceImpl

  def contact
  end

  def about
  end

  def home
      locService = LocationServiceImpl.instance
      @locations = locService.studyLocations
  end

  def terms
  end

  def signin
  end

  def signup
  end

end