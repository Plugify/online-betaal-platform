require './lib/online_betaal_platform'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'dotenv/load'

require 'byebug'

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures"
  c.hook_into :webmock
end

# Configure the gem
OnlineBetaalPlatform.configure do |config|
  config.live_mode = false
  config.api_user_key = ENV['API_USER_KEY']
  config.merchant_notify_url = ENV['MERCHANT_NOTIFY_URL']
end

