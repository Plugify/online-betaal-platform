require 'byebug'
require 'rack'
module OnlineBetaalPlatform
  # Multi Transaction
  class MultiTransaction
    attr_reader :uid, :object, :created, :updated, :completed, :checkout,
      :payment_method, :payment_flow, :payment_details, :amount, :return_url,
      :redirect_url, :notify_url, :status, :metadata, :statuses, :transactions

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
      @payment_flow    = attributes['payment_flow']
      @payment_details = attributes['payment_details']
      @amount          = attributes['amount']
      @return_url      = attributes['return_url']
      @redirect_url    = attributes['redirect_url']
      @notify_url      = attributes['notify_url']
      @status          = attributes['status']
      @metadata        = attributes['metadata']
      @statuses        = attributes['statuses']
      @transactions    = attributes['transactions'].map do |attrs|
        OnlineBetaalPlatform::MerchantTransaction.new(attrs)
      end rescue []
      @total_price = @transactions.map{ |tr| tr.total_price.to_i }.sum || 0
    end

    def self.create(attributes)
      attributes[:notify_url] = notify_url
      multi_transcation = Request.post(api_url, attributes)

      # Return the created merchant
      new(multi_transcation)
    end

    def self.all
      # TODO: Handle pagination
      multi_transactions = Request.get(api_url)['data']
      multi_transactions.map { |attributes| new(attributes) }
    end

  end
end
