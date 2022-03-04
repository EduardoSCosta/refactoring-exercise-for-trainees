class PurchasesController < ApplicationController
  def create
    valid_gateway, gateway_error = ValidateGatewayService.call(purchase_params[:gateway])

    return error_message(gateway_error) unless valid_gateway

    cart, cart_error = FindCartService.call(purchase_params[:cart_id])

    return error_message(cart_error) unless cart

    user, user_errors = CreateUserService.call(purchase_params[:user], cart)

    return error_message(user_errors) unless user_errors.nil?

    order, order_errors = CreateOrderService.call(user, address_params, cart)

    return error_message(order_errors) unless order_errors.nil?

    render json: { status: :success, order: { id: order.id } }, status: :ok
  end

  private

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end

  def address_params
    purchase_params[:address] || {}
  end

  def error_message(error)
    render json: { errors: error }, status: :unprocessable_entity
  end
end
