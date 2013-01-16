# encoding: utf-8

class Contributor
	require 'net/http'

	attr_accessor :name,:institution,:studyTitle,:numberOfPredatorSpecies,
	:timePeriod,:numberOfInteractions,:numberOfPreyTaxa

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

		storey = Contributor.new
		storey.name = "Malcolm Storey"
		storey.institution = "http://bioinfo.org.uk"
		storey.timePeriod = ""
		storey.studyTitle = "Food webs and species interactions in the Biodiversity of UK and Ireland."
		studies["BIO_INFO"] = storey

		paris = Contributor.new
		paris.name = "Jose R Ferrer Paris"
		paris.institution = "Centro de Estudios Botánicos y Agroforestales, Instituto Venezolano de Investigaciones Científicas; Kirstenbosch Research Center, South African National Biodiversity Institute"
		paris.timePeriod = ""
		paris.studyTitle = "Compilation of hostplant records for butterflies."
		studies["JRFerrisParisButterflies"] = paris

		spire = Contributor.new
		spire.name = "Joel Sachs"
		spire.institution = "Dept. of Computer Science and Electrical Engineering, University of Maryland Baltimore County, Baltimore, MD, USA."
		spire.timePeriod = ""
		spire.studyTitle = "Semantic Prototypes in Research Ecoinformatics (SPIRE)."
		studies["SPIRE"] = spire


		query = "START study=node:studies('*:*') 
		MATCH study-[:COLLECTED]->predator-[:CLASSIFIED_AS]->taxon 
		RETURN distinct(study.title), count(distinct(taxon.name))"
		
		body = executeQuery(query)
		
		body['data'].each do |dat| 
			p dat
			contributor = studies[dat[0]]
			if contributor 
				contributor.numberOfPredatorSpecies = dat[1]
			end
		end

		query = "START study=node:studies('*:*') 
		MATCH study-[:COLLECTED]->predator-[ateRel:ATE|PREYS_UPON|PARASITE_OF|HAS_HOST|INTERACTS_WITH]->prey-[:CLASSIFIED_AS]->taxon 
		RETURN distinct(study.title), count(ateRel), count(distinct(taxon))"
		
		body = executeQuery(query)
		
		contributors = Array.new
		body['data'].each do |dat| 
			p dat
			contributor = studies[dat[0]]
			if contributor 
				contributor.numberOfInteractions = dat[1]
				contributor.numberOfPreyTaxa = dat[2]
				contributors << contributor
			end
		end


		contributors
	end

	def self.executeQuery(query)
		uri = URI(Settings.neo4j_service)
		response = Net::HTTP.post_form(uri, 'query' => query)
		body = JSON.parse response.body
	end

end
