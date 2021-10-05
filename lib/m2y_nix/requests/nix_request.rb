require 'httparty'

module M2yNix
  class NixRequest
    def initialize(access_key)
      @headers = {
        'Content-Type' => 'application/json',
        'Authorization' => access_key
      }
    end

    def get(url)
      puts url.to_s
      req = HTTParty.get(url, headers: @headers)
      req.parsed_response
    end

    def post(url, body)
      puts url.to_s
      req = HTTParty.post(url,
                          body: body.to_json,
                          headers: @headers)
      req.parsed_response
    end
  end
end
