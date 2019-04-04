# OnlineBetaalPlatform

Wrapper gem for [Online Betaal Platform API](https://onlinebetaalplatform.nl/nl/public/developer/api) 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'online_betaal_platform'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install online_betaal_platform

## Usage

Add the config block to your rails app:

```ruby
# config/initializers/online_betaal_platform.rb
OnlineBetaalPlatform.configure do |config|
  config.live_mode = false
  config.api_user_key = ENV['API_USER_KEY']
  config.notify_url = ENV['MERCHANT_NOTIFY_URL']
  config.bank_account_redirect_url = ENV['BANK_ACCOUNT_REDIRECT_URL']
end
```

## API reference

### Merchants:

Get all merchants:

```ruby
OnlineBetaalPlatform::Merchant.all
```
Find a merchant:
```ruby
OnlineBetaalPlatform::Merchant.find(uuid) 
```
Create a merchant:

```ruby
attributes =
 {
    emailaddress: "bob@marley.com",
    phone: '123123123',
    type: 'business',
    country: 'nld',
    coc_nr: '123123123'
 }
 
 OnlineBetaalPlatform::Merchant.create(attributes)
```
### Bank Accounts:
Bank accounts are linked to merchants:

```ruby
merchant = OnlineBetaalPlatform::Merchant.find('uuid')
bank_accounts = merchant.bank_accounts
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/plugify/online_betaal_platform. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OnlineBetaalPlatform project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/plugify/online_betaal_platform/blob/master/CODE_OF_CONDUCT.md).
