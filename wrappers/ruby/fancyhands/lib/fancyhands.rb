require 'forwardable'
require "fancyhands/version"
require 'fancyhands/configuration'

module Fancyhands
  extend SingleForwardable

  def self.config
    @config ||= Fancyhands::Configuration.from_config
  end

  def_delegators :config, :key, :secret
end
