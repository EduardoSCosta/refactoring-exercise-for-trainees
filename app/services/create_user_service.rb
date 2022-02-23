class CreateUserService < ApplicationService
  def initialize(user, cart)
    @user = user
    @cart = cart
  end
  private_class_method :new

  def call
    return @cart.user unless @cart.user.nil?

    user_params = @user ? @user : {}
    User.create(**user_params.merge(guest: true))
  end
end
