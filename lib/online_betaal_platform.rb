require 'http'
require 'oj'
require 'dry-validation'

require 'online_betaal_platform/configuration'
# require "online_betaal_platform/version"
require "online_betaal_platform/merchant"

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
