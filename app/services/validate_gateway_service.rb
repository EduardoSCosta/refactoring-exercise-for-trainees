class ValidateGatewayService < ApplicationService
  AVAILABLE_GATEWAYS = %w[paypal stripe].freeze

  def initialize(gateway)
    @gateway = gateway
  end
  private_class_method :new

  def call
    valid_gateway = AVAILABLE_GATEWAYS.include?(@gateway)
    gateway_error = [{ message: 'Gateway not supported!' }]

    [valid_gateway, gateway_error]
  end
end
