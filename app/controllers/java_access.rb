
class JavaAccess


  include_class Java::org.trophic.graph.service.LocationServiceImpl

  def get_list
    locService = LocationServiceImpl.instance
    @locations = locService.studyLocations
    @locations
  end
  
end
