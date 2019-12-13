module OnlineBetaalPlatform
  # Product
  class IdealIssuer
    attr_reader :name, :bic

    def self.api_url
      'ideal_issuers'
    end

    def initialize(attributes)
      @bic = attributes['bic']
      @name = attributes['name']
    end

    def self.all
      # TODO: Handle pagination
      ideal_issuers = Request.get(api_url)['data']
      ideal_issuers.map { |attributes| new(attributes) }
    end
  end
end
