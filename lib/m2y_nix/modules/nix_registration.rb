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

    def pj_account(params, access_token)
      body = {
        channel_code: params[:channel_code],
        entity: "entity",
        activity_code: params[:activity_code],
        user_id: params[:user_id],
        business_name: params[:business_name],
        cnpj: params[:cnpj],
        business_trading_name: params[:business_trading_name],
        business_email: params[:business_email],
        business_type: params[:business_type],
        business_size: params[:business_size],
        business_address_number: params[:business_address_number],
        business_address_neighborhood: params[:business_address_neighborhood],
        business_address_complement: params[:business_address_complement],
        business_address_country: params[:business_address_country],
        business_address_line: params[:business_address_line],
        business_address_city: params[:business_address_city],
        business_address_state: params[:business_address_state],
        business_address_zip_code: params[:business_address_zip_code],
        document_type: params[:document_type],
        document_back: params[:document_back],
        document_front: params[:document_front],
        selfie: params[:selfie]
      }
      
      body[:state_registration] = params[:state_registration] if params[:state_registration].present?
      response = HTTParty.post(
        "#{@url}/companies",
        body: body,
        headers: {
          'Authorization': access_token
        }
      )
      p response
    end

    def code(params)
      code = params[:code]
      response = @request.get(@url + '/channels/' + code.to_s)
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

    def patch_pf_documents(params, access_token)
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
