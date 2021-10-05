require 'json'

module M2yNix
	class NixHelper
		
		def self.homologation?(env)
			env == HOMOLOGATION
		end
		
		def self.nixBodyToString(json)
			string = "?"
			arr = []
			json.keys.each do |key|
				if !json[key].nil?
					arr << key.to_s + "=" + json[key].to_s
				end
			end
			string + arr.join("&")
		end

		def self.generate_general_response(input)
			nixErrorHandler = NixErrorHandler.new
			response = {}
			if nixErrorHandler.mapErrorType(input)
				response = {
						success: false,
						error: nixErrorHandler
				}
			else
				response = {
						success: true,
						content: input
				}
			end
			response
		end
	end
end


