require 'httparty'

module M2yNix
  class NixRequest
    def initialize(access_key = nil)
      @headers = {
        'Content-Type' => 'application/json'
        # 
      }
      @headers['Authorization'] = access_key unless access_key.nil?
    end

    def get(url, query_params = {})
      puts url.to_s
      req = HTTParty.get(url, headers: @headers, query: query_params)
      if req.parsed_response.is_a?(Array)
        return req.parsed_response if req.parsed_response.first.blank?
        req.parsed_response.first['response_status'] = req.code
        response = req.parsed_response
      elsif req.parsed_response.blank?
        response = { code: req.code}
      else 
        req.parsed_response['response_status'] = req.code
        response = req.parsed_response
      end
      response
    end

    def post(url, body, headers = {})
      puts url.to_s
      req = HTTParty.post(url,
                          body: body.to_json,
                          headers: @headers.merge(headers))
      if req.parsed_response.is_a?(Array)
        return req.parsed_response if req.parsed_response.first.blank?
        req.parsed_response.first['response_status'] = req.code
        response = req.parsed_response
      elsif req.parsed_response.blank?
        response = { code: req.code}
      else 
        req.parsed_response['response_status'] = req.code
        response = req.parsed_response
      end
      return req.parsed_response if url.include?('companies_sa_ltda')
      response
    end

    def put(url, body, headers = {})
      puts url.to_s
      req = HTTParty.put(url,
                          body: body.to_json,
                          headers: @headers.merge(headers))
      req.parsed_response
    end
  end
end
