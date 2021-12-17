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
  
      if response.include?('code') || response.include?('errors') 
        unless response['message'].nil?
          if response['message'].include?('digitable')
            return { error: 'Código de barras inválido'}
          elsif response['message'].include?('provider') || response['message'].include?('InternalServerError')
            return { error: 'Erro inesperado, tente novamente mais tarde.'}
          end
        end
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
        return {message: 'Faltando Parametros'}, status: 400
      end
      model
    end

    def pay_billet(params)
      if params[:schedule_date].blank?
        billet = {
          barcode: params[:barcode],
          amount: params[:amount],
          due_date: params[:due_date],
          origin: params[:origin],
          app_name: params[:app_name],
          description: params[:description],
          validation_id: params[:validation_id]
        }
        response = @request.post(@url + PAYAMENT_PATH + '/nix', billet, { 'social-number': params[:social_number] })
      else  
        billet = {
          amount: params[:amount],
          code: params[:code],
          description: params[:description].present? ? params[:description] : nil,
          schedule_date: params[:schedule_date]
        }
        response = @request.post(@url + PAYAMENT_PATH + '/schedule', billet)
      end 

      if response.include?('errors') || response['message'] != 'None'
      elsif response.dig['message'] == 'None'
        return { error: 'Boleto já Baixado.' }
      end 
      if response['code'] == '500' || response.include?('DOCTYPE')
        return { error: 'Erro inesperado, tente novamente mais tarde.' }
      end

      model = NixModel.new
      begin
        model.status_code = 200
        model.schedule_id = response['id']
        model.schedule_status = response['status']
        model.schedule_authentication_code = response['authentication_code']
        model.schedule_type = response['type']
        model.schedule_code = response['code']
        model.schedule_date = response['schedule_date']
        model.amount = response['amount']
        model.description = response['description']
        model.sender_account = response['account']
        model.sender_name = response['name']
        model.sender_social_number = response['social_number']
        model.sender_branch = response['branch']
        model.bank_code = response['code']
        model.bank_account_type = response['account_type']
        model.bank_name = response['bank_name']
        model.recipient_social_name = response['social_name']
        model.recipient_document = response['document']
        model.recipient_emissor = response['emissor']
        model.recipient_due_date = response['due_date']
        model.recipient_barcode = response['barcode']
        model.token = response['token']

      rescue StandardError 
        return { message: 'Faltando Parametros' }
      end

      model
    end
  end
end
