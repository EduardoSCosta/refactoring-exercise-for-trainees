class ValidateGatewayService < ApplicationService
  AVAILABLE_GATEWAYS = %w[paypal stripe].freeze

  def initialize(gateway)
    @gateway = gateway
  end
  private_class_method :new

  def call
    AVAILABLE_GATEWAYS.include?(@gateway)
  end
end
