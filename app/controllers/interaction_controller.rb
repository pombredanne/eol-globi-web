class InteractionController < ApplicationController

  def foot_chain
    species   = params[:species]
    if species.nil? || species.empty?
      species = "Callinectes sapidus"
    end

    preys     = InteractionService.preys     species
    predators = InteractionService.predators species

    respond_to do |format|
      format.html {  }
      format.json {
        resp = build_wheel species, preys, predators
        render :json => "[#{resp}]"
      }
    end
  end

  private

    def build_wheel( species, preys, predators )
      resp = ""
      species_id = species.gsub(" ", "_")
      prey_ids = Array.new
      pred_ids = Array.new
      preys.each do |prey|
        id = prey[0].gsub(" ", "_")
        next if id.eql?(species_id)
        prey_ids.push id
        resp += "{"
        resp += "\"connections\": [\"#{species_id}\"],"
        resp += "\"text\": \"#{prey[0]}\","
        resp += "\"id\": \"#{id}\","
        resp += "\"version\": \"\""
        resp += "},"
      end
      predators.each do |predator|
        id = predator[0].gsub(" ", "_")
        next if id.eql?(species_id)
        pred_ids.push id
        resp += "{"
        resp += "\"connections\": [\"#{species_id}\"],"
        resp += "\"text\": \"#{predator[0]}\","
        resp += "\"id\": \"#{id}\","
        resp += "\"version\": \"\""
        resp += "},"
      end
      connections = prey_ids + pred_ids
      connection_string = connections.join("\", \"")
      pred_string = pred_ids.join("\", \"")
      resp += "{"
      resp += "\"connections\":  [\"#{connection_string}\"],"
      resp += "\"dependencies\": [\"#{pred_string}\"],"
      resp += "\"text\": \"#{species}\","
      resp += "\"id\": \"#{species_id}\","
      resp += "\"version\": \"\""
      resp += "},"
      end_point = resp.length - 2
      resp = resp[0..end_point]
      resp
    end

end


