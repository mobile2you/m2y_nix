module M2yNix
  class NixAccessToken
    def initialize
    end

    def self.auth(username, password)
      HTTParty.post('https://apigateway-tst.nexxera.com/nix/cadun/auth', body: { user: username, password: password })
    end
  end
end
