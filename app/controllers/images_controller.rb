class ImagesController < ApplicationController

  def thumbnails
    respond_to do |format|
      format.json {
        image_id_param = params[:image_id]
        image_ids = image_id_param.split(":")
        image_id = image_ids[0] + ":" + image_ids[1]
        index = image_ids[2]
        response = RestClient.get("http://trophicgraph.com:8080/images/#{image_id}")
        if response && !response.empty?
          json = JSON.parse response
          json['index'] = index
          render json: json
        else
          render json: "{\"error\": \"empty\" }"
        end
      }
    end
  rescue => e
    Rails.logger.error e.message
    e.backtrace.each do |message|
      Rails.logger.error message
    end
    nil
  end

end
