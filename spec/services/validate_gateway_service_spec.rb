require 'rails_helper'

RSpec.describe ValidateGatewayService do
  describe '#call' do
    context 'when gateway is valid' do
      let(:gateway) { 'paypal' }
      it 'returns true' do
        expect(ValidateGatewayService.call(gateway)).to eq(true)
      end
    end

    context 'when gateway is invalid' do
      let(:gateway) { 'not_a_gateway' }
      it 'returns false' do
        expect(ValidateGatewayService.call(gateway)).to eq(false)
      end
    end
  end
end
