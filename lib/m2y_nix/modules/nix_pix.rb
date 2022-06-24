# frozen_string_literal: true

module M2yNix
  class NixPix < NixModule
    def initialize(access_key)
      startModule(access_key)
      @token = access_key
    end

    def create_key(body)
      @request.post("#{@url}/pix/create_key", body)
    end

    def account_keys
      @request.get("#{@url}/pix/key_by_account")
    end

    def account_info_by_key(adressing_key)
      @request.get("#{@url}/pix/addressing/#{adressing_key}")
    end 

    def cash_out_key(body)
      HTTParty.post(
        @url + '/pix/cash_out/key',
        body: body,
        headers: {
          Authorization: @token,
          'Content-Type' => 'application/json'
        }
      )
    end

    def pix_manual(body)
      HTTParty.post(
        @url + '/pix/manual',
        body: body,
        headers: {
          Authorization: @token,
          'Content-Type' => 'application/json'
        }
      )
    end

    def home_qr_code(body)
      HTTParty.post(
        @url + '/pix/qrcode/static/home',
        body: body,
        headers: {
          Authorization: @token,
          'Content-Type' => 'application/json'
        }
      )
    end

    def delete_key(key)
      url = @url + '/pix/delete_key/' + key.to_s
      puts url 
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
