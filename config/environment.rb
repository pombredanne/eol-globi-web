# Load the rails application
require File.expand_path('../application', __FILE__)

class Settings
	raw_config = File.read("#{::Rails.root.to_s}/config/config.yml")
	erb_config = ERB.new(raw_config).result
	settings = YAML.load(erb_config)[::Rails.env]
    
	if settings
		settings.each { |name, value|
			instance_variable_set("@#{name}", value)
			self.class.class_eval { attr_reader name.intern }
		}
	end
end

# Initialize the rails application
TrophicWeb::Application.initialize!
