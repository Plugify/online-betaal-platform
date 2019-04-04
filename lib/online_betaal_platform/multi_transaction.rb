require 'byebug'
require 'rack'
module OnlineBetaalPlatform
  # Multi Transaction
  class MultiTransaction
    attr_reader :uid, :object, :created, :updated, :completed, :checkout,
      :payment_method, :payment_flow, :payment_details, :amount, :return_url,
      :redirect_url, :notify_url, :status, :metadata, :statuses, :transactions

    def self.api_url
      OnlineBetaalPlatform.configuration.api_root_url + '/multi_transactions'
    end

    def self.http_auth
      OnlineBetaalPlatform.configuration.http_auth
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

      byebug
      attributes[:notify_url] = notify_url
      Rack::Utils.parse_nested_query(params)
      response = http_auth.post(api_url, body: URI.encode_www_form(attributes))

      # Raise any API errors
      raise response.parse.to_s if response.code != 200

      # Return the created merchant
      new(Oj.load(response))
    end

    def self.all
      # TODO: Handle pagination
      response = http_auth.get(api_url)
      multi_transcations = Oj.load(response.body)['data']
      multi_transcations.map { |attributes| new(attributes) }
    end

  end
end
