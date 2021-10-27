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
  end
end