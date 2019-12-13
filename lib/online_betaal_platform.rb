# Require needed gems & files
require 'oj'

require 'online_betaal_platform/configuration'
require 'online_betaal_platform/request'
require 'online_betaal_platform/merchant'
require 'online_betaal_platform/bank_account'
require 'online_betaal_platform/multi_transaction'
require 'online_betaal_platform/merchant_transaction'
require 'online_betaal_platform/product'
require 'online_betaal_platform/ideal_issuer'

module OnlineBetaalPlatform
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
