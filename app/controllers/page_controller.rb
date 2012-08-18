class PageController < ApplicationController

  def contact
  end

  def about
  end

  def home
    render :layout => 'application_lp'
  end

  def locations
    respond_to do |format|
      format.json { 
        locations = Location.fetch_locations
        render :json => locations.to_json 
      }
    end
  end
  
  def location
    @lat = params[:lat]
    @lon = params[:lon]
    if @lat && @lon 
      @specimens = Specimen.fetch_specimens(@lat, @lon) 
      p "#{@specimens.count}"
    end
  end

  def terms
  end

  def signin
  end

  def signup
  end

end