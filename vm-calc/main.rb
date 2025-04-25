require 'sinatra'
require 'csv'
require 'json'
require_relative 'lib/constants'
require_relative 'lib/data_loader'
require_relative 'lib/vm_calculator'

set :bind, '0.0.0.0'
set :port, 5678

PRICES = DataLoader.load_prices(Constants::PRICES_FILE)

get '/calculate' do
  content_type :json

  begin
    # Parse query parameters
    os = params['os']
    cpu = params['cpu'].to_i
    ram = params['ram'].to_i
    hdd_type = params['hdd_type']
    hdd_capacity = params['hdd_capacity'].to_i
    volumes = JSON.parse(params['volumes'] || '[]')
    
    errors = []

    # Check params
    errors << "Parameter 'cpu' is required" if params['cpu'].nil? || params['cpu'].empty?
    errors << "Parameter 'ram' is required" if params['ram'].nil? || params['ram'].empty?
    errors << "Parameter 'hdd_type' is required" if params['hdd_type'].nil? || params['hdd_type'].empty?
    errors << "Parameter 'hdd_capacity' is required" if params['hdd_capacity'].nil? || params['hdd_capacity'].empty? 

    # Check values
    errors << "CPU must be positive" if cpu <= 0
    errors << "RAM must be positive" if ram <= 0
    errors << "HDD capacity must be positive" if hdd_capacity <= 0

    # Check volumes
    volumes.each do |volume|
      if volume['capacity'] && volume['capacity'].to_i <= 0
        errors << "Volume capacity must be positive"
      end
    end

    # Validate required parameters
    halt 400, { errors: errors }.to_json unless errors.empty?

    # Calculate cost using VmCalculator's method?
    vm_calculator = VmCalculator.new(PRICES)
    cost = vm_calculator.calculate_cost(cpu, ram, hdd_type, hdd_capacity, volumes, os)

    # Return the calculated cost
    { cost: cost }.to_json
  rescue JSON::ParserError
    halt 400, { errors: ['Invalid JSON format for volumes'] }.to_json
  rescue => e
    halt 500, { errors: ["Internal server error: #{e.message}"] }.to_json
  end
end