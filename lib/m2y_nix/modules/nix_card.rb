# frozen_string_literal: true

module M2yNix
  class NixCard < NixModule
    def initialize(access_key)
      startModule(access_key)
    end

    def create(body)
      @request.post("#{@url}#{CARD_PATH}/#{body[:card_type].downcase}", body.except!(:card_type))
    end

    def get_virtual(access_key)
      headers = {
        'Authorization': access_key,
        'Content-Type' => 'application/json'
      }
      HTTParty.get("#{@url}#{CARD_PATH}/virtual", headers: headers)
    end

    def activate(body, access_key)
      headers = {
        'Authorization': access_key,
        'Content-Type' => 'application/json'
      }
      HTTParty.patch("#{@url}#{CARD_PATH}/activate", body: body, headers: headers)
    end

    def cancel(body, access_key)
      headers = {
        'Authorization': access_key,
        'Content-Type' => 'application/json'
      }
      HTTParty.patch("#{@url}#{CARD_PATH}/cancel", body: body, headers: headers)
    end

    def change_password(body, access_key)
      headers = {
        'Authorization': access_key,
        'Content-Type' => 'application/json'
      }
      HTTParty.patch("#{@url}#{CARD_PATH}/password", body: body, headers: headers)
    end

    def sensitive_info(body)
      @request.post(@url + CARD_PATH + '/pci', body)
    end

    def statement(body)
      @request.get(@url + CARD_PATH + '/statement', body)
    end

    def get_physical
      @request.get(@url + CARD_PATH + '/physical')
    end
  end
end
