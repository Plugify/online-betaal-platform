require './lib/online_betaal_platform'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'dotenv/load'

require 'byebug'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures'
  c.hook_into :webmock
end

# Configure the gem
OnlineBetaalPlatform.configure do |config|
  config.live_mode = false
  config.api_user_key = ENV['API_USER_KEY']
  config.notify_url = ENV['MERCHANT_NOTIFY_URL']
  config.bank_account_redirect_url = ENV['BANK_ACCOUNT_REDIRECT_URL']
end
