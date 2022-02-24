class FindCartService < ApplicationService
  def initialize(cart_id)
    @cart_id = cart_id
  end
  private_class_method :new

  def call
    cart = Cart.find_by(id: @cart_id)
    cart_error = [{ message: 'Cart not found!' }]

    [cart, cart_error]
  end
end
