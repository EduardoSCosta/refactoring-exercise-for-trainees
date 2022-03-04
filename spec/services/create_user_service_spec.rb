require 'rails_helper'

RSpec.describe CreateUserService do
  describe '#call' do
    subject(:call) { CreateUserService.call(user_params, cart) }
    context 'user is logged in' do
      let!(:user) { User.create(email: 'user@test.com', first_name: 'Test', last_name: 'User', guest: false) }
      let!(:cart) { Cart.create(user_id: user.id) }
      let(:user_params) { { email: 'user@test.com', first_name: 'Test', last_name: 'User' } }

      it 'does not create a new user' do
        expect { call }.not_to change(User, :count)
      end

      it 'does not create a new user as a guest' do
        call
        expect(User.last.guest).to eq(false)
      end
    end

    context 'user is not logged in' do
      let(:cart) { Cart.create(user: nil) }
      let(:user_params) { { email: 'user@test.com', first_name: 'Test', last_name: 'User' } }

      it 'creates new user' do
        expect { call }.to change(User, :count).by(1)
      end

      it 'creates new user as a guest' do
        call
        expect(User.last.guest).to eq(true)
      end
    end

    context 'user does not exists' do
      let(:cart) { Cart.create(user: nil) }
      let(:user_params) { {} }
      it 'return error messages' do
        (_, user_errors) = call
        expect(user_errors).to eq(
          [
            { message: "Email can't be blank" },
            { message: "First name can't be blank" },
            { message: "Last name can't be blank" }
          ]
        )
      end
    end
  end
end
