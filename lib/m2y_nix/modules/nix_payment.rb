module M2yNix
  class NixPayment < NixModule
    def initialize(access_key)
      startModule(access_key)
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
