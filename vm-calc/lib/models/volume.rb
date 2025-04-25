module Models
  class Volume
    attr_reader :type, :capacity

    def initialize(type:, capacity:)
      @type = type
      @capacity = capacity
    end
  end
end