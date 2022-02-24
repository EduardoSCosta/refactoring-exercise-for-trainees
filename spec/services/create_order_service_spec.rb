require 'rails_helper'

RSpec.describe CreateOrderService do
  describe '#call' do
    subject(:call) { CreateOrderService.call(user, address_params, cart) }
    context 'order data is valid' do
      let!(:user) { User.create(email: 'user@test.com', first_name: 'Test', last_name: 'User', guest: false) }
      let!(:cart) { Cart.create(user_id: user.id) }
      let(:address_params) { {} }
      let(:sale) { Sale.create(name: 'Test Sale', unit_price_cents: 9001) }

      it 'creates a new order' do
        expect { call }.to change(Order, :count).by(1)
      end

      it 'creates order line items' do
        CartItem.create(cart: cart, sale: sale, quantity: 2)
        expect { call }.to change(OrderLineItem, :count).by(2)
      end
    end
  end
end
