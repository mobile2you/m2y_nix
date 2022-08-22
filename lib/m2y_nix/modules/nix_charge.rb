# frozen_string_literal: true

module M2yNix
    class NixCharge < NixModule
      def initialize(access_key)
        startModule(access_key)
        @token = access_key
      end
      
      def charges(params)
        url = @url + '/charges'
        puts url 
        HTTParty.get(
          url,
          query: params,
          headers: {
            Authorization: @token,
            'Content-Type' => 'application/json'
          }
        )
      end

      def charges_by_link(body)
        url = @url + '/charges/link'
        puts url 
        HTTParty.post(
          url,
          body: body,
          headers: {
            Authorization: @token,
            'Content-Type' => 'application/json'
          }
        )
      end

      def charge(id)
        url = @url + '/charges/' + id.to_s
        puts url 
        HTTParty.get(
          url,
          headers: {
            Authorization: @token,
            'Content-Type' => 'application/json'
          }
        )
      end

      def resend(id, body)
        url = @url + '/charges/resend/' + id.to_s
        HTTParty.post(
          url,
          body: body,
          headers: {
            Authorization: @token,
            'Content-Type' => 'application/json'
          }
        )
      end

      def delete(id)
        url = @url + '/charges/resend/' + id.to_s
        HTTParty.delete(
          url,
          headers: {
            Authorization: @token,
            'Content-Type' => 'application/json'
          }
        )        
      end
    end
  end
  