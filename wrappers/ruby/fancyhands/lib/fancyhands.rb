require 'forwardable'
require "fancyhands/version"
require 'fancyhands/configuration'
require 'fancyhands/v1'

module Fancyhands
  extend SingleForwardable

  def self.config
    @config ||= Fancyhands::Configuration.from_config
  end

  def_delegators :config, :key, :secret
end
