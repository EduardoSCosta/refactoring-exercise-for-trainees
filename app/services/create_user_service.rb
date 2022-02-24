class CreateUserService < ApplicationService
  def initialize(params, cart)
    @params = params
    @cart = cart
  end
  private_class_method :new

  def call
    return @cart.user unless @cart.user.nil?

    params = @params ? @params : {}
    user = User.create(**params.merge(guest: true))

    user_errors = user.errors.map(&:full_message).map { |message| { message: message } }

    [user, user_errors]
  end
end
