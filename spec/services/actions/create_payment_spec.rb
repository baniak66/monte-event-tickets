# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::CreatePayment do
  let(:user)        { create :user }
  let(:event)       { create :event }
  let(:reservation) { create :reservation, event: event, user: user }

  describe 'call' do
    let(:amount)   { 100 }
    let(:token)    { 'token' }
    let(:instance) { described_class.new(reservation_id: reservation.id, amount: amount, token: token) }

    context 'valid operation' do
      before do
        result = Adapters::Payment::Gateway::Result.new(amount, 'EUR')
        allow(Adapters::Payment::Gateway).to receive(:charge).and_return(result)
      end

      it 'creates payment record' do
        expect { instance.call }.to change { Payment.count }.from(0).to(1)
      end

      it 'creates payment with proper attributes' do
        instance.call
        payment = Payment.first

        expect(payment.reservation_id).to eq(reservation.id)
        expect(payment.amount).to eq(amount)
        expect(payment.currency).to eq('EUR')
      end

      it 'returns success response object' do
        expect(instance.call).to be_instance_of(Actions::Response::Success)
      end

      it 'updates reservation status to paid' do
        expect{ instance.call }.to change{ reservation.reload.state }.from('initialized').to('paid')
      end
    end

    context 'operation raises error' do
      it 'returns error response object' do
        allow(Adapters::Payment::Gateway).to receive(:charge)
          .and_raise(Adapters::Payment::Gateway::PaymentError)

        expect(instance.call).to be_instance_of(Actions::Response::Error)
      end
    end

    context 'error occured durring save payment record' do
      let(:reservation) { double(id: 'fake_id') }

      it 'returns error response object' do
        expect(instance.call).to be_instance_of(Actions::Response::Error)
      end
    end
  end
end
