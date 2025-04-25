require 'net/http'
require 'uri'

class OrderService
  include Authentification
  attr_reader :session, :params

  def initialize(session, params)
    @session, @params = session, params
  end

  def check
    Authentification::require_login
    config_data = fetch_configurations
    validate_configuration!(config_data)
    cost = calculate_cost(config_data)
    check_balance!(cost)

    build_success_response(cost)
  rescue => e
    handle_service_error(e)
  end

  private

  def fetch_configurations
    uri = URI(Rails.application.config.possible_orders_url)
    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise Errors::ConfigurationFetchFailed, 
        "Failed to fetch configurations: #{response.code}"
    end

    JSON.parse(response.body)
  rescue => e
    raise Errors::ServiceUnavailable, 
      "Configuration service unavailable: #{e.message}"
  end

  def validate_configuration!(config_data)
    specs = config_data['specs']
    matching_spec = specs.find do |spec|
      spec['os'].include?(params[:os]) &&
      spec['cpu'].include?(params[:cpu].to_i) &&
      spec['ram'].include?(params[:ram].to_i) &&
      spec['hdd_type'].include?(params[:hdd_type]) &&
      @params[:hdd_capacity].to_i.between?(
        spec['hdd_capacity'][@params[:hdd_type]]['from'].to_i,
        spec['hdd_capacity'][@params[:hdd_type]]['to'].to_i
      )
    end

    return if matching_spec

    error_details = {
      os: params[:os],
      cpu: params[:cpu],
      ram: params[:ram],
      hdd_type: params[:hdd_type],
      hdd_capacity: params[:hdd_capacity]
    }
    raise Errors::InvalidConfiguration.new(error_details)
  end

  def calculate_cost(config_data)
    calculate_uri = URI(Rails.application.config.vm_calc_url)
    calculate_uri.query = URI.encode_www_form(
      params.slice(:os, :cpu, :ram, :hdd_type, :hdd_capacity)
           .merge(volumes: [].to_json)
    )

    response = Net::HTTP.get_response(calculate_uri)
    
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)['cost'].to_f
    when Net::HTTPClientError
      raise Errors::InvalidParameters, 
        "Invalid parameters: #{response.body}"
    when Net::HTTPServerError
      raise Errors::ServiceUnavailable, 
        "Calculation service error: #{response.body}"
    else
      raise Errors::CostCalculationFailed, 
        "Unexpected response: #{response.code}"
    end
  rescue => e
    raise Errors::ServiceUnavailable, 
      "Calculation service unavailable: #{e.message}"
  end

  def check_balance!(cost)
    return if session[:balance].to_f >= cost
    raise Errors::InsufficientFunds.new(
      current_balance: session[:balance],
      required_amount: cost
    )
  end

  def build_success_response(cost)
    {
      result: true,
      total: cost,
      balance: session[:balance],
      balance_after_transaction: session[:balance] - cost
    }
  end

  def handle_service_error(error)
    case error
    when Errors::OrderServiceError
      raise
    when Net::HTTPError, JSON::ParserError
      raise Errors::ServiceUnavailable, error.message
    else
      raise Errors::ServiceError, "Unexpected error: #{error.message}"
    end
  end
end