require 'rails_helper'

RSpec.describe CreateUserService do
  describe '#call' do
    context 'user is logged in' do
      let!(:user) { User.create(email: 'user@test.com', first_name: 'Test', last_name: 'User', guest: false) }
      let!(:cart) { Cart.create(user_id: user.id) }

      it 'does not create a new user' do
        expect { CreateUserService.call(user, cart) }.not_to change(User, :count)
      end

      it 'does not create a new user as a guest' do
        expect(User.last.guest).to eq(false)
      end
    end

    context 'user is not logged in' do
      let(:cart) { Cart.create(user: nil) }
      let(:user) { { email: 'user@test.com', first_name: 'Test', last_name: 'User' } }

      it 'creates new user' do
        expect { CreateUserService.call(user, cart) }.to change(User, :count).by(1)
      end

      it 'creates new user as a guest' do
        CreateUserService.call(user, cart)
        expect(User.last.guest).to eq(true)
      end
    end
  end
end
