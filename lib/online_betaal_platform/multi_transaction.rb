module OnlineBetaalPlatform
  # Multi Transaction
  class MultiTransaction
    attr_reader :uid, :object, :created, :updated, :completed, :checkout,
      :payment_method, :payment_flow, :payment_details, :amount, :return_url,
      :redirect_url, :notify_url, :status, :metadata, :statuses, :issuer,
      :merchant_transactions, :date_expired

    def self.api_url
      'multi_transactions'
    end

    def self.notify_url
      OnlineBetaalPlatform.configuration.notify_url
    end

    def initialize(attributes)
      @uid             = attributes['uid']
      @object          = attributes['object']
      @created         = attributes['created']
      @updated         = attributes['updated']
      @completed       = attributes['completed']
      @checkout        = attributes['checkout']
      @payment_method  = attributes['payment_method']
      @issuer          = attributes['issuer']
      @payment_flow    = attributes['payment_flow']
      @payment_details = attributes['payment_details']
      @amount          = attributes['amount']
      @return_url      = attributes['return_url']
      @redirect_url    = attributes['redirect_url']
      @notify_url      = attributes['notify_url']
      @status          = attributes['status']
      @metadata        = attributes['metadata']
      @statuses        = attributes['statuses']
      @date_expired    = attributes['date_expired']
      @merchant_transactions = attributes.fetch('transactions', []).map do |attrs|
        OnlineBetaalPlatform::MerchantTransaction.new(attrs)
      end
      @total_price = @merchant_transactions.map{ |tr| tr.total_price.to_i }.sum || 0
    end

    def self.create(attributes)
      attributes[:notify_url] = notify_url
      multi_transcation = Request.post(api_url, attributes)

      # Return the created merchant
      new(multi_transcation)
    end

    def self.all(page = 1, per_page = 10, filters = {})
      # TODO: Handle pagination
      multi_transactions = Request.get(api_url, page, per_page, filters)['data']
      multi_transactions.map { |attributes| new(attributes) }
    end

    def self.find(uid)
      multi_transaction = Request.get("#{api_url}/#{uid}")
      new(multi_transaction)
    end

    def reload
      OnlineBetaalPlatform::MultiTransaction.find(uid)
    end

    def find_merchant_tansaction(merchant_transaction_uid)
      merchant_transaction = Request.get(
        "#{MultiTransaction.api_url}/#{uid}/transactions/#{merchant_transaction_uid}"
      )
      MerchantTransaction.new(merchant_transaction)
    end
  end
end
