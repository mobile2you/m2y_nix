# frozen_string_literal: true

module M2yNix
  class NixPix < NixModule
    def initialize(access_key)
      startModule(access_key)
    end

    def create_key(body)
      @request.post("#{@url}/pix/create_key", body)
    end

    def account_keys
      @request.get("#{@url}/pix/key_by_account")
    end
  end
end
