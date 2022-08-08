require 'json'

module M2yNix
  class NixHelper
    def self.homologation?(env)
      env == HOMOLOGATION
    end

    def self.nixBodyToString(json)
      string = '?'
      arr = []
      json.keys.each do |key|
        arr << key.to_s + '=' + json[key].to_s unless json[key].nil?
      end
      string + arr.join('&')
    end

    def self.generate_general_response(input)
      nixErrorHandler = NixErrorHandler.new
      response = {}
      if nixErrorHandler.mapErrorType(input)
        {
          success: false,
          error: nixErrorHandler
        }
      else
        {
          success: true,
          content: input
        }
      end
    end
  end
end
