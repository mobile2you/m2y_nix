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
        recipient_branch: "0001",
        recipient_bank_code: "332",
        recipient_account_type: 'CHECKING', # Verificar o que podemos mandar nesse campo
        recipient_bank_name: "Acesso Soluções De Pagamento S.A."
      }

      response = @request.post(@url + ACCOUNT_PATH + TRANSFER_PATH, body)

      response
    end

    def transfer_bank(params)
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
        recipient_bank_name: recipient[:bank][:name]
      }

      response = @request.post(@url + ACCOUNT_PATH + TRANSFER_PATH + '/bank', body)

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

    def statement(params)
      body = {
        start_event_date: params[:start_event_date],
        event_model: 'TRANSFER'
      }
     
      @request.get(@url + ACCOUNT_PATH + STATEMENT_PATH, body)
    end
  end
end
