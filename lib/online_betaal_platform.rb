# Require needed gems & files

require 'http'
require 'oj'
require 'dry-validation'

require 'online_betaal_platform/configuration'
require 'online_betaal_platform/merchant'
require 'online_betaal_platform/bank_account'

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
