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
    @lng = params[:lng]
    if @lat && @lng
      @specimens = Specimen.fetch_specimens(@lat, @lng)
    end
  end

  def location_count
    lat = params[:lat]
    lng = params[:lng]
    specimens_count = 0
    if lat && lng
      specimens_count = Specimen.fetch_specimens_count(lat, lng)
    end
    respond_to do |format|
      format.text {
        render :text => specimens_count
      }
    end
  end

  def search
    @species = params[:species]
    p "#{@species}"
  end

  def data_contributors
    @contributors = Contributor.fetch_contributors
  end

  def info
	@info = Info.fetch_info
  end

  def interactions
    @nw_lat = params[:nw_lat]
    @nw_lng = params[:nw_lng]
    @se_lat = params[:se_lat]
    @se_lng = params[:se_lng]

    unless @nw_lat && @nw_lng && @se_lat && @se_lng
      @nw_lat = 41.574361
      @nw_lng = -125.533448
      @se_lat = 32.750323
      @se_lng = -114.744873
    end

    render :layout => 'page_interactions'
  end

  def terms
  end

  def signin
  end

  def signup
  end

  def code_of_ethics
  end

end
