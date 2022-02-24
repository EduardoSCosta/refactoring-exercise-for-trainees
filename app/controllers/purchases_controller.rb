class PurchasesController < ApplicationController
  def create
    unless ValidateGatewayService.call(purchase_params[:gateway])
      return render json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity
    end

    (cart, cart_error) = FindCartService.call(purchase_params[:cart_id])

    return render json: { errors: cart_error }, status: :unprocessable_entity unless cart

    (user, user_errors) = CreateUserService.call(purchase_params[:user], cart)

    return render json: { errors: user_errors }, status: :unprocessable_entity unless user_errors.nil?

    (order, order_errors) = CreateOrderService.call(user, address_params, cart)

    return render json: { errors: order_errors }, status: :unprocessable_entity unless order_errors.nil?

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
end
