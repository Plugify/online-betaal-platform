module OnlineBetaalPlatform
  # Merchant transaction
  class MerchantTransaction
    attr_reader :uid, :object, :created, :updated, :completed, :checkout,
      :payment_method, :payment_flow, :payment_details, :amount, :return_url,
      :redirect_url, :notify_url, :status, :metadata, :statuses, :merchant_uid,
      :escrow, :merchant_profile_uid, :total_price, :shipping_costs, :products,
      :partner_fee

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
      @return_url      = attributes['return_url']
      @redirect_url    = attributes['redirect_url']
      @notify_url      = attributes['notify_url']
      @status          = attributes['status']
      @metadata        = attributes['metadata']
      @statuses        = attributes['statuses']
      @order           = attributes['orders']
      @escrow          = attributes['escrow']
      @shipping_costs  = attributes['shipping_costs']
      @partner_fee     = attributes['partner_fee']
      @merchant_profile_uid = attributes['merchant_profile_uid']

      @products = attributes['products'].map do |attrs|
        OnlineBetaalPlatform::Product.new(attrs)
      end

      @total_price = @products.map { |p| p.price.to_i }.sum || 0
    end
  end
end
