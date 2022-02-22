class ValidateGatewayService
  AVAILABLE_GATEWAYS = %w[paypal stripe].freeze

  def self.call(gateway)
    new(gateway).call
  end

  def initialize(gateway)
    @gateway = gateway
  end

  def call
    AVAILABLE_GATEWAYS.include?(@gateway)
  end
end
