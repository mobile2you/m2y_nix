module M2yNix

  class NixAccount < NixModule
    def def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def balance
      response = @request.get(@url + '/balance')
      model = NixModel.new

      model.balance = response.dig('balance', 'available', 'amount')

      model.balance.present? ? model : "Unavailable"
    end 

  end
end