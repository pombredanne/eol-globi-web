# encoding: utf-8

class Contributor
	require 'net/http'

	attr_accessor :name,:institution,:studyTitle,:numberOfPredatorSpecies,
	:timePeriod,:numberOfInteractions,:numberOfPreyTaxa

	def self.fetch_contributors
		query = "START study=node:studies('*:*')
		MATCH study-[:COLLECTED]->sourceSpecimen-[interact:ATE|PREYS_UPON|PARASITE_OF|HAS_HOST|INTERACTS_WITH]->prey-[:CLASSIFIED_AS]->targetTaxon, sourceSpecimen-[:CLASSIFIED_AS]->sourceTaxon
		RETURN study.institution, study.period, study.description, study.contributor, count(interact), count(distinct(sourceTaxon)), count(distinct(targetTaxon))"
		
		body = executeQuery(query)

    contributors = Array.new
		body['data'].each do |dat| 
			p dat
			contributor = Contributor.new
			contributor.institution = dat[0]
			contributor.timePeriod = dat[1]
			contributor.studyTitle = dat[2]
			contributor.name = dat[3]
      contributor.numberOfInteractions = dat[4]
      contributor.numberOfPredatorSpecies = dat[5]
      contributor.numberOfPreyTaxa = dat[6]
      contributors << contributor
		end

		contributors
	end

	def self.executeQuery(query)
		uri = URI(Settings.neo4j_service)
		response = Net::HTTP.post_form(uri, 'query' => query)
		body = JSON.parse response.body
	end

end
