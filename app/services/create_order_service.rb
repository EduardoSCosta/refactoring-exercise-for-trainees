class CreateOrderService < ApplicationService
  SHIPPING_COSTS = 100

  def initialize(user, address_params, cart)
    @user = user
    @address_params = address_params
    @cart = cart
  end
  private_class_method :new

  def call
    order = new_order

    add_order_items(order)

    order.save
    order_errors = order.errors.map(&:full_message).map { |message| { message: message } }

    [order, order_errors]
  end

  private

  def new_order
    Order.new(
      user: @user,
      first_name: @user.first_name,
      last_name: @user.last_name,
      address_1: @address_params[:address_1],
      address_2: @address_params[:address_2],
      city: @address_params[:city],
      state: @address_params[:state],
      country: @address_params[:country],
      zip: @address_params[:zip]
    )
  end

  def add_order_items(order)
    @cart.items.each do |item|
      item.quantity.times do
        order.items << OrderLineItem.new(
          order: order,
          sale: item.sale,
          unit_price_cents: item.sale.unit_price_cents,
          shipping_costs_cents: SHIPPING_COSTS,
          paid_price_cents: item.sale.unit_price_cents + SHIPPING_COSTS
        )
      end
    end
  end
end
