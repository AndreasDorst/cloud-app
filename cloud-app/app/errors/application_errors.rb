module Errors
  class OrderServiceError < StandardError; end
  class ServiceUnavailable < OrderServiceError; end
  class InvalidConfiguration < OrderServiceError; end
  class ConfigurationFetchFailed < OrderServiceError; end
  class CostCalculationFailed < OrderServiceError; end
  class InsufficientFunds < OrderServiceError; end
  class Unauthorized < OrderServiceError; end
end