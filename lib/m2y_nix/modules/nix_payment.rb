module M2yNix
  class NixPayment < NixModule
    def initialize(access_key)
      startModule(access_key)
      @token = access_key
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
        recipient_bank_name: recipient[:bank][:name]
      }
      @request.post(@url + ACCOUNT_PATH + TRANSFER_PATH + '/bank', body)
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

    def transfer_statement(params)
      body = {
        start_event_date: params[:start_event_date],
        end_event_date: params[:end_event_date],
        event_model: 'TRANSFER'
      }
      @request.get(@url + ACCOUNT_PATH + STATEMENT_PATH, body)
    end

    def find_payment_by_barcode(barcode)
      response = @request.post(@url + PAYMENT_PATH + '/bankly-validate-barcode', { "barcode": barcode })
    end

    def pay_billet(params)
      if params[:schedule_date] == Date.today.strftime('%Y-%m-%d')
        billet = {
          barcode: params[:barcode],
          amount: params[:amount],
          due_date: params[:due_date],
          origin: params[:origin],
          app_name: params[:app_name],
          description: params[:description],
          validation_id: params[:validation_id]
        }
        response = @request.post(@url + PAYMENT_PATH + '/nix', billet, { 'social-number': params[:social_number] })
      else
        billet = {
          amount: params[:amount],
          code: params[:barcode],
          description: params[:description].present? ? params[:description] : nil,
          schedule_date: params[:schedule_date]
        }
        response = @request.post(@url + PAYMENT_PATH + '/schedule', billet)
      end
    end

    def payments_list(params)
      HTTParty.get(
        @url + ACCOUNT_PATH + STATEMENT_PATH,
        query: params,
        headers: {
          Authorization: @token,
          'Content-Type' => 'application/json'
        }
      )
    end
  end
end
