module M2yNixAuth
  def initialize
    @url = 'https://apigateway-tst.nexxera.com/nix/cadun/empresas/auth'
  end

  def auth(username, password)
    Httparty.post(@url, body: { user: username, password: password })
  end
end
