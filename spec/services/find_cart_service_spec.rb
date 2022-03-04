require 'rails_helper'

RSpec.describe FindCartService do
  describe '#call' do
    subject(:call) { FindCartService.call(1) }
    let!(:user) { User.create(email: 'user@test.com', first_name: 'Test', last_name: 'User', guest: false) }
    context 'when cart exists' do
      it 'returns cart with id 1' do
        Cart.create(user_id: user.id)
        (cart,) = call
        expect(cart.id).to eq(1)
      end
    end

    context 'when cart does not exists' do
      it 'returns nil' do
        (cart,) = call
        expect(cart).to eq(nil)
      end

      it 'returns a error message' do
        (_, cart_error) = call
        expect(cart_error).to eq([{ message: 'Cart not found!' }])
      end
    end
  end
end
