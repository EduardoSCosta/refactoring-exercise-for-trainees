require 'rails_helper'

RSpec.describe ValidateGatewayService do
  describe '#call' do
    subject(:call) { ValidateGatewayService.call(gateway) }
    context 'when gateway is valid' do
      let(:gateway) { 'paypal' }
      it 'returns true' do
        (valid_gateway,) = call
        expect(valid_gateway).to eq(true)
      end
    end

    context 'when gateway is invalid' do
      let(:gateway) { 'not_a_gateway' }
      it 'returns false' do
        (valid_gateway,) = call
        expect(valid_gateway).to eq(false)
      end

      it 'returns false' do
        (_, gateway_error) = call
        expect(gateway_error).to eq([{ message: 'Gateway not supported!' }])
      end
    end
  end
end
