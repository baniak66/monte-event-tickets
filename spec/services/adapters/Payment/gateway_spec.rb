# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Adapters::Payment::Gateway do
  describe 'self.charge' do
    let(:amount) { 100 }

    context 'valid token' do
      let(:token) { 'valid token' }

      it 'retruns result object' do
        expect(described_class.charge(amount: amount, token: token))
          .to be_instance_of(Adapters::Payment::Gateway::Result)
      end

      it 'retruns result with proper values' do
        result = described_class.charge(amount: amount, token: token)
        expect(result.amount).to eq(amount)
        expect(result.currency).to eq("EUR")
      end
    end

    context 'invalid token' do
      context 'card error' do
        let(:token) { 'card_error' }

        it 'raises card_error error' do
          expect { described_class.charge(amount: amount, token: token) }
            .to raise_error(Adapters::Payment::Gateway::CardError)
        end
      end

      context 'payment error' do
        let(:token) { 'payment_error' }

        it 'raises payment_error error' do
          expect { described_class.charge(amount: amount, token: token) }
            .to raise_error(Adapters::Payment::Gateway::PaymentError)
        end
      end
    end
  end
end
