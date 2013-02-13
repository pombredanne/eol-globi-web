# encoding: utf-8

class Contributor
	require 'net/http'

	attr_accessor :name,:institution,:studyTitle,:numberOfPredatorSpecies,
	:timePeriod,:numberOfInteractions,:numberOfPreyTaxa

	def self.fetch_contributors
		# note that this data should be moved into the neo4j database at some point
		studies = Hash.new

		query = "START study=node:studies('*:*') 
		MATCH study-[:COLLECTED]->predator-[:CLASSIFIED_AS]->taxon 
		RETURN study.title, study.institution, study.period, study.description, study.contributor, count(distinct(taxon.name))"
		
		body = executeQuery(query)
		
		body['data'].each do |dat| 
			p dat
			contributor = Contributor.new
			contributor.institution = dat[1]
			contributor.timePeriod = dat[2]
			contributor.studyTitle = dat[3]
			contributor.name = dat[4]
			contributor.numberOfPredatorSpecies = dat[5]
			studies[dat[0]] = contributor
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
