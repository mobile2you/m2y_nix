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

    def find_account_by_document(document)
      response = @request.get(@url + ACCOUNT_PATH, { "customer_id": document }).first
      model = NixModel.new

      begin
        model.status_code = 200
        model.name = response['name']
        model.account_number = "#{response['account_number']}-#{response['account_check_digit']}"
        model.bank_number = response['bank_number']
        model.branch_number = response['branch_number']
      rescue StandardError
        model.status_code = 404
      end
      model
    end

    def statement(params)
      body = {
        start_event_date: params[:start_event_date],
        end_event_date: params[:end_event_date],
        limit: params[:limit],
        offset: params[:offset]
      }
      @request.get(@url + ACCOUNT_PATH + STATEMENT_PATH, body)
    end

    def status
      @request.get(@url + USER_PATH + '/pf' + '/list')
    end

    def companies_status
      @request.get(@url + '/companies')
    end

    def transaction_password(params)
      body = { password: params[:password] }
      @request.post(@url + '/transaction_auth', body)
    end

    def transaction_password_exist
      @request.get(@url + '/transaction_auth/exists')
    end

    def change_transaction_password(params)
      body = {
        new_password: params[:new],
        old_password: params[:old]
        }
      @request.post(@url + '/transaction_auth/change_password', body)
    end

    def auth_transaction_password(params)
      body = { password: params[:password] }
      @request.post(@url + '/transaction_auth/authenticate', body)
    end

    def reset_pass(params)
      body = { user: params[:cpf] }
      if @url.include?('qa')  
        response = @request.post('https://apigateway-qa.nexxera.com/nix/cadun/empresas/user/reset_password', body)
      else
        response = @request.post('https://apigateway.nexxera.com/nix/cadun/empresas/user/reset_password', body)
      end
      response
    end
  end
end
