require 'm2y_nix/configurations/configuration'
require 'm2y_nix/constants/constants'
require 'm2y_nix/errorHandler/nix_error_handler'
require 'm2y_nix/helpers/nix_helper'
require 'm2y_nix/modules/nix_modules'
require 'm2y_nix/modules/nix_module'
require 'm2y_nix/models/nix_models'
require 'm2y_nix/requests/nix_request'

module M2yNix
  # Gives access to the current Configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.with_configuration(config)
    original_config = {}

    config.each do |key, value|
      original_config[key] = configuration.send(key)
      configuration.send("#{key}=", value)
    end

    yield if block_given?
  ensure
    original_config.each { |key, value| configuration.send("#{key}=", value) }
  end
end
