module OnlineBetaalPlatform
  # Merchant transaction
  class MerchantTransaction
    attr_reader :uid, :object, :created, :updated, :completed, :checkout,
      :payment_method, :payment_flow, :payment_details, :amount, :return_url,
      :redirect_url, :notify_url, :status, :metadata, :statuses, :merchant_uid,
      :escrow, :escrow_date, :merchant_profile_uid, :total_price, :shipping_costs,
      :products, :partner_fee, :issuer

    def self.api_url
      "transactions"
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
      @merchant_uid    = attributes['merchant_uid']
      @checkout        = attributes['checkout']
      @payment_method  = attributes['payment_method']
      @payment_flow    = attributes['payment_flow']
      @payment_details = attributes['payment_details']
      @amount          = attributes['amount']
      @issuer          = attributes['issuer']
      @return_url      = attributes['return_url']
      @redirect_url    = attributes['redirect_url']
      @notify_url      = attributes['notify_url']
      @status          = attributes['status']
      @metadata        = attributes['metadata']
      @statuses        = attributes['statuses']
      @order           = attributes['orders']
      @escrow          = attributes['escrow']
      @escrow_date     = attributes['escrow_date']
      @shipping_costs  = attributes['shipping_costs']
      @partner_fee     = attributes['partner_fee']
      @merchant_profile_uid = attributes['merchant_profile_uid']

      @products = attributes.fetch(products, []).map do |attrs|
        OnlineBetaalPlatform::Product.new(attrs)
      end

      @total_price = @products.map { |p| p.price.to_i }.sum || 0

      @merchant = unless @merchant_uid.empty?
                    OnlineBetaalPlatform::Merchant.find(@merchant_uid)
                  else
                    nil
                  end
    end

    def self.find(uid)
      merchant_transaction = Request.get(
        "#{api_url}/#{uid}"
      )
      new(merchant_transaction)
    end

    def update_escrow(escrow_date)
      Request.post(MerchantTransaction.api_url + "/#{uid}", {escrow_date: escrow_date})
    end

    def refund!(amount = self.amount, message = 'Transaction Refunded')
      Request.post(MerchantTransaction.api_url + "/#{uid}" + '/refunds', {
        amount: amount,
        message: message
      })
    end

    def self.create(attributes)
      attributes[:notify_url] = notify_url
      merchant_transcation = Request.post(api_url, attributes)

      # Return the created merchant
      new(merchant_transcation)
    end
  end
end
