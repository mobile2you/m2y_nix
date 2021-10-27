module M2yNix
  class NixPayment < NixModule
    def initialize(access_key)
      startModule(access_key)
    end

    def transfer(params)
      # body = {
      #   type: String,
      #   amount: Float,
      #   description: String,
      #   recipient: {
      #     account: String,
      #     name: String,
      #     social_number: String,
      #     branch: String,
      #     bank: {
      #       code: String,
      #       name: String
      #     },
      #     account_type: String
      #   }
      # }

      recipient = params[:recipient]
      bank = params[:recipient][:bank]

      body = {
        "amount": params[:amount],
        "description": params[:description], # Opcional
        "recipient_account": recipient[:account],
        "recipient_name": recipient[:name],
        "recipient_social_number": recipient[:social_number],
        "recipient_branch": recipient[:branch],
        "recipient_account_type": recipient[:account_type],
        "recipient_bank_code": bank[:code],
        "recipient_bank_name": bank[:name]
      }

      if body[:type] == 'NIX'
        response = @request.post(@url + TRANSFER_PATH + '/bank', body)
      elsif body[:type] == 'BANK_TRANFER'
        response = @request.post(@url + TRANSFER_PATH, body)
      end
    end
  end
end
