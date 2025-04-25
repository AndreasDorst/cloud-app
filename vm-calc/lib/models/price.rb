module Models
  class Price
    attr_reader :type, :price

    def initialize(type:, price:)
      @type = type
      @price = price
    end
  end
end