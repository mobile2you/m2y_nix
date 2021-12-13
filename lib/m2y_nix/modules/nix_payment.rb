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
        recipient_bank_name: recipient[:bank][:name]
      }

      if recipient[:bank][:code] == "332"
        response = @request.post(@url + ACCOUNT_PATH + TRANSFER_PATH, body)
      else
        response = @request.post(@url + ACCOUNT_PATH + TRANSFER_PATH + '/bank', body)
      end

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

    def find_payment_by_barcode(barcode)
      response = @request.post(@url + PAYAMENT_PATH + '/bankly-validate-barcode', { "barcode": barcode })
      if response.include?('code') || response.include?('message')
        return { error: response.dig('message')}
      end
      
      model = NixModel.new
      begin
        model.status_code = 200
        model.validation_id = response['id']
        model.original_amount = response['originalAmount']
        model.amount = response['amount']
        model.due_date = response['dueDate']
        model.assignor = response['assignor']
        model.digitable = response['digitable']
        model.recipient = response['recipient']
        model.max_amount = response['maxAmount']
        model.min_amount = response['minAmount']
        model.allow_change_amount = response['allowChangeAmount']
        model.interest_amount_calculated = response['charges']['interestAmountCalculated']
        model.fine_amount_calculated = response['charges']['fineAmountCalculated']
        model.discount_amount = response['charges']['discountAmount']
      rescue StandardError 
        #Todo melhorar o tratamento desse retorno
        return {message: 'Missing params'}
      end
      
      model
    end
  end
end
