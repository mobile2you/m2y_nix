module M2yNix
  class NixAccessToken
    def initialize; end

    def self.auth(username, password)
      @url = M2yNix.configuration.server_url
      if @url.include?('qa')
        HTTParty.post(
          'https://apigateway-qa.nexxera.com/nix/cadun/empresas/auth',
          body: { user: username, password: password }
        )
      else
        HTTParty.post(
          'https://apigateway.nexxera.com/nix/cadun/empresas/auth',
          body: { user: username, password: password }
        )
      end
    end

    def self.refresh(token)
      @url = M2yNix.configuration.server_url
      if @url.include?('qa')
        HTTParty.post(
          'https://apigateway-qa.nexxera.com/nix/cadun/empresas/auth/refresh',
          headers: { 'Refresh-Token': token }
        )
      else
        HTTParty.post(
          'https://apigateway.nexxera.com/nix/cadun/empresas/auth/refresh',
          headers: { 'Refresh-Token': token }
        )
      end
    end
  end
end
