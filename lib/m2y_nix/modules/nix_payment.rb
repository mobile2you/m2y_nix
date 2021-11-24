module M2yNix
  class NixPayment < NixModule
    def initialize(access_key)
      startModule(access_key)
    end

    def transfer(params)
      recipient = params[:recipient]

      body = {
        amount: params[:amount],
        recipient_account: recipient[:account],
        description: params[:description],
        recipient_name: recipient[:name],
        recipient_social_number: recipient[:social_number],
        recipient_branch: recipient[:branch],
        recipient_bank_code: recipient[:bank][:code],
        recipient_account_type: 'CHECKING', # Verificar o que podemos mandar nesse campo
        recipient_bank_name: params[:type].zero? ? recipient[:bank][:name] : 'NIX'
      }

      url = @url + ACCOUNT_PATH + TRANSFER_PATH

      url += '/bank' if params[:type].zero?

      response = @request.post(url, body)

      response
    end

    def fees
      response = @request.get(@url + FEE_PATH)
      if response.dig('results')
        response['results'].map do |fee|
          {
            transaction_type: fee['transaction_type'],
            installment: fee['installment'],
            time_to_receive: fee['time_to_receive'],
            time_to_receive_type: fee['time_to_receive_type'],
            fee_type: fee['fee_type'],
            amount: fee['amount']
          }
        end
      end
    end
  end
end
