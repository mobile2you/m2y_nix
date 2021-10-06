# frozen_string_literal: true

module M2yNix
  class Configuration
    def initialize #:nodoc:
      @server_url = nil
    end

    attr_accessor :server_url
  end
end
