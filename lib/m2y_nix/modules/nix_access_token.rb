module M2yNix
  class NixAccessToken
    def initialize
    end

    def self.auth(username, password)
      HTTParty.post(
        'https://apigateway-qa.nexxera.com/nix/cadun/empresas/auth',
        body: { user: username, password: password }
      )
    end

    def self.refresh(token)
      p @url
      HTTParty.post(
        'https://apigateway-qa.nexxera.com/nix/cadun/empresas/auth/refresh',
        headers: { 'Refresh-Token': token }
      )
    end
  end
end
