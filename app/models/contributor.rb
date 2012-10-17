class Contributor
	require 'net/http'

	attr_accessor :name,:institution,:studyTitle,:numberOfPredatorSpecies,:timePeriod

	def self.fetch_contributors
		# note that this data should be moved into the neo4j database at some point
		studies = Hash.new
		blewett = Contributor.new
		blewett.name = "David A. Blewett"
		blewett.institution = "Fish and Wildlife Research Institute, Florida Fish and Wildlife Conservation Commission"
		blewett.timePeriod = "Mar 2000- Feb 2002"
		blewett.studyTitle = "Feeding Habits of Common Snook, Centropomus undecimalis, in Charlotte Harbor, Florida"
		studies["Blewett2000CharlotteHarborFL"] = blewett

		akin = Contributor.new
		akin.name = "S. Akin"
		akin.institution = "Section of Ecology, Evolutionary Biology and Systematics, Department of Wildlife and Fisheries Sciences,
Texas A&M University"
		akin.timePeriod = "Mar 1998- Aug 1999"
		akin.studyTitle = "Seasonal Variation in Food Web Composition and Structure in a Temperate Tidal Estuary"
		studies["akinMadIsland"] = akin

		simons = Contributor.new
		simons.name = "James D. Simons"
		simons.institution = "Center for Coastal Studies, Texas A&M University - Corpus Christi"
		simons.timePeriod = "1987-1990"
		simons.studyTitle = "Food habits and trophic structure of the demersal fish assemblages on the Mississippi-Alabama continental shelf"
		studies["simons/mississippiAlabamaFishDiet.csv.gz"] = simons

		baremore = Contributor.new
		baremore.name = "Ivy E. Baremore"
		baremore.institution = "University of Florida, Department of Fisheries and Aquatic Sciences"
		baremore.timePeriod = "2005"
		baremore.studyTitle = "Prey Selection By The Atlantic Angel Shark Squatina Dumeril In The Northeastern Gulf Of Mexico"
		studies["BAREMORE_ANGEL_SHARK"] = baremore

		wrast = Contributor.new
		wrast.name ="Jenny L. Wrast"
		wrast.institution = "Department of Life Sciences Texas A&M University-Corpus Christi"
		wrast.timePeriod = "July 2006 - April 2007"
		wrast.studyTitle = "Spatiotemporal And Habitat-Mediated Food Web Dynamics in Lavaca Bay, Texas"
		studies["wrast/lavacaBayTrophicData.csv.gz"] = wrast

		query = "START study=node:studies('*:*') 
		MATCH study-[:COLLECTED]->predator-[:CLASSIFIED_AS]->taxon 
		RETURN distinct(study.title), count(distinct(taxon.name))"
		
		uri = URI(Settings.neo4j_service)
		response = Net::HTTP.post_form(uri, 'query' => query)
		body = JSON.parse response.body
		contributors = Array.new
		body['data'].each do |dat| 
			p dat
			contributor = studies[dat[0]]
			if contributor 
				contributor.numberOfPredatorSpecies = dat[1]
				contributors << contributor
			end
		end
		contributors
	end
end