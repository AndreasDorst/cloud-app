module Models
  class VM
    attr_reader :cpu, :ram, :hdd_type, :hdd_capacity, :os

    def initialize(cpu:, ram:, hdd_type:, hdd_capacity:, os: nil)
      @cpu = cpu
      @ram = ram
      @hdd_type = hdd_type
      @hdd_capacity = hdd_capacity
      @os = os
    end

    def total_cost(prices)
      cpu_cost = @cpu * (prices[:cpu] ? prices[:cpu].price : 0)
      ram_cost = @ram * (prices[:ram] ? prices[:ram].price : 0)
      hdd_cost = @hdd_capacity * (prices[@hdd_type.to_sym] ? prices[@hdd_type.to_sym].price : 0)
      os_cost = @os ? (prices[:os] ? prices[:os].price : 0) : 0
      cpu_cost + ram_cost + hdd_cost + os_cost
    end

    def add_volume(volume_type, capacity)
      @hdd_capacity += capacity
    end
  end
end