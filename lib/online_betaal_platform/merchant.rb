module OnlineBetaalPlatform
  # Merchant endpoint
  class Merchant
    attr_reader :livemode, :uid, :object, :created, :updated, :status,
                :compliance, :type, :coc_nr, :name, :phone, :vat_nr, :country,
                :sector, :notify_url, :addresses, :trading_names, :contacts,
                :profiles, :payment_methods
    def self.api_url
      'merchants'
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
      merchant = Request.get("#{api_url}/#{uid}")

      new(merchant)
    end

    def self.all(page = 1, per_page = 10)
      # TODO: Handle pagination
      merchants = Request.get(api_url, page, per_page)['data']
      merchants.map { |attributes| new(attributes) }
    end

    def self.last
      self.all.last
    end

    def self.first
      self.all.first
    end

    def self.create(attributes)
      attributes[:notify_url] = notify_url
      merchant = Request.post(api_url, attributes)

      # Return the created merchant
      new(merchant)
    end

    def bank_accounts
      # GET Request to /merchants/:merchant_uid/bank_accounts
      bank_accounts = Request.get(
        "#{OnlineBetaalPlatform::Merchant.api_url}/#{uid}/bank_accounts"
      )['data']
      return [] if bank_accounts.empty?

      bank_accounts.map do |attributes|
        OnlineBetaalPlatform::BankAccount.new(attributes)
      end
    end

    def default_bank_account
      bank_accounts.select(&:is_default)&.first
    end

    def new_bank_account_link
      form = {
        notify_url: OnlineBetaalPlatform::Merchant.notify_url,
        return_url: OnlineBetaalPlatform::Merchant.bank_account_redirect_url
      }

      bank_account_link = Request.post(
        OnlineBetaalPlatform::Merchant.api_url + '/' + uid + '/bank_accounts',
        form
      )

      OnlineBetaalPlatform::BankAccount.new(bank_account_link)
    end

    def migrate_to_business_merchant(coc_nr, country = 'NLD')
      raise "Can't migrate business account" if type == 'business'
      form = {
        notify_url: OnlineBetaalPlatform::Merchant.notify_url,
        coc_nr: coc_nr,
        country: country
      }
      response = Request.post(
        OnlineBetaalPlatform::Merchant.api_url + '/' + uid + '/migrate',
        form
      )
      response
    end
  end
end
