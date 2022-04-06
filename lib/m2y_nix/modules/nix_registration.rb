require 'net/http'
require 'uri'

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

    def sa_ltda_account(params)
      url = URI("#{@url}/companies_sa_ltda")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      form_data = []
      form_data << ['channel_code', params[:channel_code]] if params[:channel_code].present?
      form_data << ['activity_code', params[:activity_code]] if params[:activity_code].present?
      form_data << ['representative_register_name', params[:representative_register_name]] if params[:representative_register_name].present?
      form_data << ['cpf', params[:cpf]] if params[:cpf].present?
      form_data << ['representative_email', params[:representative_email]] if params[:representative_email].present?
      form_data << ['state_registration', params[:state_registration].present? ? params[:state_registration] : '']
      form_data << ['representative_phone_number', params[:representative_phone_number]] if params[:representative_phone_number].present?
      form_data << ['representative_birth_date', params[:representative_birth_date]] if params[:representative_birth_date].present?
      form_data << ['representative_mother_name', params[:representative_mother_name]] if params[:representative_mother_name].present?
      form_data << ['representative_social_name', params[:representative_social_name]] if params[:representative_social_name].present?
      form_data << ['representative_phone_country_code', '55']
      form_data << ['representative_address_number', params[:representative_address_number]] if params[:representative_address_number].present?
      form_data << ['representative_address_neighborhood', params[:representative_address_neighborhood]] if params[:representative_address_neighborhood].present?
      form_data << ['representative_address_complement', params[:representative_address_complement].present? ? params[:representative_address_complement] : '']
      form_data << ['representative_address_line', params[:representative_address_line]] if params[:representative_address_line].present?
      form_data << ['representative_address_city', params[:representative_address_city]] if params[:representative_address_city].present?
      form_data << ['representative_address_state', params[:representative_address_state]] if params[:representative_address_state].present?
      form_data << ['representative_address_zip_code', params[:representative_address_zip_code]] if params[:representative_address_zip_code].present?
      form_data << ['representative_password', params[:representative_password]] if params[:representative_password].present?
      form_data << ['business_name', params[:business_name]] if params[:business_name].present?
      form_data << ['cnpj', params[:cnpj]] if params[:cnpj].present?
      form_data << ['business_email', params[:business_email]] if params[:business_email].present?
      form_data << ['business_type', params[:business_type]] if params[:business_type].present?
      form_data << ['business_size', params[:business_size]] if params[:business_size].present?
      form_data << ['business_trading_name', params[:business_trading_name]] if params[:business_trading_name].present?
      form_data << ['business_address_number', params[:business_address_number]] if params[:business_address_number].present?
      form_data << ['business_address_neighborhood', params[:business_address_neighborhood]] if params[:business_address_neighborhood].present?
      form_data << ['business_address_line', params[:business_address_line]] if params[:business_address_line].present?
      form_data << ['business_address_city', params[:business_address_city]] if params[:business_address_city].present?
      form_data << ['business_address_state', params[:business_address_state]] if params[:business_address_state].present?
      form_data << ['business_address_complement', params[:business_address_complement].present? ? params[:business_address_complement] : '']
      form_data << ['business_address_zip_code', params[:business_address_zip_code]] if params[:business_address_zip_code].present?
      form_data << ['documents', (params[:documents]).to_s] if params[:documents].present?
      request.set_form form_data, 'multipart/form-data'
      https.request(request)
    end

    def pj_account(params, access_token)
      body = {
        channel_code: params[:channel_code],
        entity: "1",
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

    def mei(params, access_token)
      body = {
        channel_code: params[:channel_code],
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
        business_address_country: params[:business_address_country],
        business_address_line: params[:business_address_line],
        business_address_city: params[:business_address_city],
        business_address_state: params[:business_address_state],
        business_address_zip_code: params[:business_address_zip_code]
      }

      body[:state_registration] = params[:state_registration].present? ? params[:state_registration] : ""
      body[:entity] = params[:entity].present? ? params[:entity] : ""
      body[:business_address_complement] = params[:business_address_complement].present? ? params[:business_address_complement] : ""
      response = HTTParty.post(
        "#{@url}/companies_mei_ei_eireli/create",
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
    def update_pf_account(params)
      address = params[:address]

      body = {
        phone: {
          countryCode: params[:country_code],
          number: params[:number]
        },
        address: {
          buildingNumber: address[:building_number],
          neighborhood: address[:neighborhood],
          complement: address[:complement],
          country: address[:country],
          addressLine: address[:address_line],
          city: address[:city],
          state: address[:state],
          zipCode: address[:zip_code]
        },
        documentNumber: params[:document_number],
        registerName: params[:name],
        socialName: params[:social_name],
        birthDate: params[:birthdate],
        motherName: params[:mother_name],
        email: params[:email]
      }
      response = @request.put('https://nix-core-qa.cloudint.nexxera.com/api/v1/users/pf', body) 
    end

    def update_pj_account(params)
      address = params[:address]
      body = {
        state_registration: params[:entity],
        business_name: params[:name],
        business_trading_name: params[:fantasy_name],
        business_address_number: address[:number],
        business_address_neighborhood: address[:neighborhood],
        business_address_complement: address[:complement],
        business_address_country: address[:country],
        business_address_line: address[:address_line],
        business_address_city: address[:city],
        business_address_state: address[:state],
        business_address_zip_code: address[:zip_code],
        business_type: params[:type],
        business_size: params[:size]
      }
      response = @request.put("https://nix-core-qa.cloudint.nexxera.com/api/v1/companies/#{params[:user_id]}", body) 
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

    def post_mei_documents(params, access_token)
      body = {
        document_type: params[:document_type],
        document_front: params[:document_front],
        document_back: params[:document_back]
      }
      url = URI("#{@url}/companies_mei_ei_eireli/documents")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Authorization"] = access_token
      form_data = [['document_front', File.open(params[:document_front])],
                  ['document_back', File.open(params[:document_back])],
                  ['document_type', params[:document_type] ]  
                ]
      request.set_form form_data, 'multipart/form-data'
      response = https.request(request)
      response
    end

    def post_mei_selfie(params, access_token)
      url = URI("#{@url}/companies_mei_ei_eireli/selfie")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Authorization"] = access_token
      form_data = [['selfie', File.open(params[:selfie])]]
      request.set_form form_data, 'multipart/form-data'
      response = https.request(request)
      response
    end
  end
end
