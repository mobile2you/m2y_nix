# frozen_string_literal: true

module M2yNix
  class NixCard < NixModule
    def initialize(access_key)
      startModule(access_key)
    end

    def create_virtual(body)
      @request.post("#{@url}#{CARD_PATH}/virtual", body)
    end

    def get_virtual(body)
      @request.get("#{@url}#{CARD_PATH}/virtual", body)
    end

    def activate(body)
      HTTParty.patch("#{@url}#{CARD_PATH}/activate", body)
    end

    def cancel(body)
      HTTParty.patch("#{@url}#{CARD_PATH}/cancel", body)
    end

    def change_password(body)
      HTTParty.patch("#{@url}#{CARD_PATH}/password", body)
    end

    def sensitive_info(body)
      @request.post("#{@url}#{CARD_PATH}/pci", body)
    end

    def statement(body)
      @request.get("#{@url}#{CARD_PATH}/statement", body)
    end
  end
end
