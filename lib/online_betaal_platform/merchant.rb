module OnlineBetaalPlatform
  # Merchant endpoint
  class Merchant
    attr_reader :livemode, :uid, :object, :created, :updated, :status,
                :compliance, :type, :coc_nr, :name, :phone, :vat_nr, :country,
                :sector, :notify_url, :addresses, :trading_names, :contacts,
                :profiles, :payment_methods

    def self.api_url
      OnlineBetaalPlatform.configuration.api_root_url + '/merchants'
    end

    def self.http_auth
      OnlineBetaalPlatform.configuration.http_auth
    end

    def self.notify_url
      OnlineBetaalPlatform.configuration.notify_url
    end

    def self.bank_account_redirect_url
      OnlineBetaalPlatform.configuration.bank_account_redirect_url
    end

    def initialize(attributes)
      @livemode = attributes['livemode']
      @uid = attributes['uid']
      @object = attributes['object']
      @created = attributes['created']
      @updated = attributes['updated']
      @status = attributes['status']
      @compliance = attributes['compliance']
      @type = attributes['type']
      @coc_nr = attributes['coc_nr']
      @name = attributes['name']
      @phone = attributes['phone']
      @vat_nr = attributes['vat_nr']
      @country = attributes['country']
      @sector = attributes['sector']
      @notify_url = attributes['notify_url']
      @addresses = attributes['addresses']
      @trading_names = attributes['trading_names']
      @contacts = attributes['contacts']
      @profiles = attributes['profiles']
      @payment_methods = attributes['payment_methods']
    end

    def self.find(uid)
      response = http_auth.get("#{api_url}/#{uid}")
      attributes = Oj.load(response.body)
      new(attributes)
    end

    def self.all
      # TODO: Handle pagination
      response = http_auth.get(api_url)
      merchants = Oj.load(response.body)['data']
      merchants.map { |attributes| new(attributes) }
    end

    def self.create(attributes)
      attributes[:notify_url] = notify_url
      response = http_auth.post(api_url, form: attributes)

      # Raise any API errors
      raise response.parse.to_s if response.code != 200

      # Return the created merchant
      new(Oj.load(response))
    end

    def bank_accounts
      # GET Request to /merchants/:merchant_uid/bank_accounts
      response = OnlineBetaalPlatform::Merchant.http_auth.get(
        OnlineBetaalPlatform::Merchant.api_url + '/' + uid + '/bank_accounts'
      )

      bank_accounts = Oj.load(response.body)['data']

      return [] if bank_accounts.empty?

      bank_accounts.map do |attributes|
        OnlineBetaalPlatform::BankAccount.new(attributes)
      end
    end

    def new_bank_account
      form = {
        notify_url: OnlineBetaalPlatform::Merchant.notify_url,
        return_url: OnlineBetaalPlatform::Merchant.bank_account_redirect_url
      }

      response = OnlineBetaalPlatform::Merchant.http_auth.post(
        OnlineBetaalPlatform::Merchant.api_url + '/' + uid + '/bank_accounts',
        form: form
      )

      OnlineBetaalPlatform::BankAccount.new(Oj.load(response.body))
    end
  end
end
