require_relative 'models'
require_relative 'constants'

class VmCalculator
  attr_reader :prices

  def initialize(prices)
    @prices = prices
  end

  def calculate_cost(cpu, ram, hdd_type, hdd_capacity, volumes, os = nil)
    # Create VM instanse
    vm = Models::VM.new(
      cpu: cpu,
      ram: ram,
      hdd_type: hdd_type,
      hdd_capacity: hdd_capacity,
      os: os
    )
    
    # Add volumes
    volumes.each do |volume|
      vm.add_volume(volume['hdd_type'], volume['capacity'].to_i)
    end
    
    # Calculate cost using VM's method
    vm.total_cost(prices) # Pass the `prices` array to the `total_cost` method
  end
end