# encoding: utf-8

class Contributor
	require 'net/http'

	attr_accessor :name,:institution,:studyTitle,:numberOfPredatorSpecies,
	:timePeriod,:numberOfInteractions,:numberOfPreyTaxa

	def self.fetch_contributors
		body = executeQuery
    p 'contributors: [' + body + ']'

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

	def self.executeQuery
		uri = URI(Settings.globi_rest_service + 'contributors')
		response = Net::HTTP.get_response( uri )
    JSON.parse response.body
	end

end
