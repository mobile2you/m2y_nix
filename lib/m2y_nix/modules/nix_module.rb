module M2yNix

  class NixModule
    def startModule(access_key)
      @request = NixRequest.new(access_key)
      @url = M2yNix.configuration.server_url
    end

    def generateResponse(input)
      NixHelper.generate_general_response(input)
    end
  end

end
