class InteractionService

  def self.preys( species_name = "Callinectes sapidus" )
    species    = URI::encode( species_name )
    preys_url  = "http://trophicgraph.com:8080/taxon/#{species}/preysOn"
    preys_body = HTTParty.get(preys_url, :headers => {"User-Agent" => "torphic" } ).response.body
    preys      = JSON.parse preys_body
    preys
  end

  def self.predators( species_name = "Callinectes sapidus" )
    species       = URI::encode( species_name )
    predator_url  = "http://trophicgraph.com:8080/taxon/#{species}/preyedUponBy"
    predator_body = HTTParty.get(predator_url, :headers => {"User-Agent" => "torphic" } ).response.body
    predators     = JSON.parse predator_body
    predators
  end

end
