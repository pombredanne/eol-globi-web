# encoding: utf-8

class Info
	require 'net/http'

	attr_accessor :total_studies,:total_interactions,:total_source_taxa,:total_target_taxa

	def self.fetch_info
		body = execute_query
		info = Info.new
		body['data'].each do |dat| 
			info.total_studies = dat[0]
			info.total_interactions = dat[1]
			info.total_source_taxa = dat[2]
			info.total_target_taxa = dat[3]
		end

		info
	end

	def self.execute_query
		uri = URI(Settings.globi_rest_service + 'info')
		response = Net::HTTP.get_response(uri)
    	JSON.parse response.body
	end

end
