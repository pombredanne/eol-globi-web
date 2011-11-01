
class JavaAccess


  include_class Java::org.trophic.graph.service.LocationServiceImpl

  def get_list
    specimenService = SpecimenServiceImpl.instance
    @specimens = specimenService.specimens
    @specimens
  end
  
end
