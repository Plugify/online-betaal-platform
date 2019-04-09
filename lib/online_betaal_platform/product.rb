module OnlineBetaalPlatform
  # Product
  class Product
    attr_reader :name, :ean, :price, :quantity

    def initialize(attributes)
      @name = attributes['name']
      @ean = attributes['ean']
      @price = attributes['price']
      @quantity = attributes['quantity']
    end
  end
end
