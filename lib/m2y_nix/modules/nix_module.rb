module M2yNix

 class NixModule

     def startModule(access_key, env)
       @request = NixRequest.new(access_key)
       @url = NixHelper.homologation?(env) ? URL_HML : URL_PRD
     end

     def generateResponse(input)
       NixHelper.generate_general_response(input)
     end
 end

end
