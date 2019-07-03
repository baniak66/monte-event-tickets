# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReleaseReservationJob do
  describe 'perform' do
    let(:event)       { create :event }
    let(:user)        { create :user }
    let(:reservation) { create :reservation, event: event, user: user }

    before do
      create :ticket, event: event, reservation_id: reservation.id, ticket_type: 'avoid_one'
      create :ticket, event: event, reservation_id: reservation.id, ticket_type: 'even'
      create :ticket, event: event, reservation_id: reservation.id, ticket_type: 'all_together'
    end

    context 'reservation not paid' do
      it 'deletes reservation' do
        expect{ described_class.perform_now(reservation.id) }.to change{ Reservation.count }.from(1).to(0)
      end

      it 'releases reservation tickets' do
        described_class.perform_now(reservation.id)
        expect(Ticket.where(reservation_id: reservation.id).count).to eq 0
        expect(Ticket.where(reservation_id: nil).count).to eq 3
      end
    end

    context 'reservation paid' do
      before do
        create :payment, reservation: reservation
      end

      it "dosen't delete reservation" do
        expect{ described_class.perform_now(reservation.id) }.not_to change{ Reservation.count }
      end

      it "dosen't release reservation tickets" do
        described_class.perform_now(reservation.id)
        expect(Ticket.where(reservation_id: reservation.id).count).to eq 3
        expect(Ticket.where(reservation_id: nil).count).to eq 0
      end
    end
  end
end


