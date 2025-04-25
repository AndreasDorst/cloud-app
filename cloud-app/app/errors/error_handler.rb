require_relative 'application_errors'

module ErrorHandler
  extend ActiveSupport::Concern

  ERROR_MAPPING = {
    Errors::ServiceUnavailable => :service_unavailable,
    Errors::InvalidConfiguration => :bad_request,
    Errors::ConfigurationFetchFailed => :service_unavailable,
    Errors::CostCalculationFailed => :not_acceptable,
    Errors::InsufficientFunds => :not_acceptable,
    Errors::Unauthorized => :unauthorized
  }.freeze

  included do
    rescue_from StandardError, with: :handle_error
    rescue_from Errors::OrderServiceError, with: :handle_order_service_error
  end

  private

  def handle_order_service_error(error)
    status = ERROR_MAPPING.fetch(error.class, :internal_server_error)
    render json: { result: false, error: error.message }, status: status
  end

  def handle_error(error)
    Rails.logger.error "Unexpected error: #{error.message}\n#{error.backtrace.join("\n")}"
    render json: { result: false, error: "Internal server error" }, status: :internal_server_error
  end
end