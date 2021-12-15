module M2yNix
  class NixRegistration < NixModule

    def initialize(access_key = nil)
      @request = NixRequest.new(access_key)
      @url = M2yNix.configuration.server_url
    end

    def cadun(params)
      address = params[:address]

      body = {
        name: params[:name],
        cpf: params[:cpf],
        password: params[:password], # Criptografar ?
        email: params[:email],
        birthday: params[:birthday],
        mother_name: params[:mother_name],
        social_name: params[:social_name],
        phone: params[:phone],
        phone_country_code: '55', # phone[:code], # Chumbado +55 ?
        address_number: address[:number],
        address_neighborhood: address[:neighborhood],
        address_complement: address[:complement],
        address_country: 'BR', # address[:country],
        address_line: address[:line],
        address_city: address[:city],
        address_state: address[:state],
        address_zip_code: address[:zip]
      }

      response = @request.post(@url + USER_PATH + CADUN_PATH, body)
      p response
    end

    def pf_account(params)
      address = params[:address]

      body = {
        phone: {
          countryCode: '55',
          number: params[:phone]
        },
        address: {
          buildingNumber: address[:number],
          neighborhood: address[:neighborhood],
          complement: address[:complement],
          country: 'BR',
          addressLine: address[:line],
          city: address[:city],
          state: address[:state],
          zipCode: address[:zip]
        },
        documentNumber: params[:cpf],
        registerName: params[:name],
        socialName: params[:social_name],
        birthDate: params[:birthday],
        motherName: params[:mother_name],
        email: params[:email]
      }

      response = @request.post(@url + USER_PATH + PF_PATH, body)
      p response
    end

    def pf_document(params, access_token)

      body = {
        'document_type' => params[:type],
        'selfie' => params[:selfie],
        'document_front' => params[:document_front],
        'document_back' => params[:document_back]
      }

      p body

      response = HTTParty.post(
        "#{@url}#{USER_PATH}#{PF_PATH}/document_images",
        body: body,
        headers: {
          'Authorization': access_token
        }
      )

      p response
      response
    end
  end
end
