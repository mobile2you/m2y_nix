module M2yNix

  class NixAccount < NixModule
    def initialize(access_key)
      startModule(access_key)
    end

    def balance
      response = @request.get(@url + ACCOUNT_PATH + '/balance')
      model = NixModel.new

      model.balance = response.dig('balance', 'available', 'amount')

      model.balance.present? ? model : response
    end 

  end
end