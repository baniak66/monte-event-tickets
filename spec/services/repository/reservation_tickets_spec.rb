# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::ReservationTickets do
  describe 'self.call' do
    let(:user)  { create :user }
    let(:event) { create :event }
    let(:reservation) { create :reservation, user: user, event: event }
    let(:result_quantity_array) do
      [
        { "quantity" => 2, "type" => "even" },
        { "quantity" => 3, "type" => "all_together" },
        { "quantity" => 5, "type" => "avoid_one" }
      ].to_json
    end
    let(:result) do
      [
        {
          "reservation_id"   => reservation.id,
          "event_name"       => event.name,
          "event_date"       => event.date.strftime("%Y-%m-%d %H:%M:%S"),
          "tickets_quantity" => result_quantity_array,
          "tickets_amount"   => 1800 # (5 * 100) + (2 * 200) + (3 * 300)
        }
      ]
    end

    before do
      create_list(:ticket, 5, event: event, ticket_type: 'avoid_one',
        price: 100, reservation_id: reservation.id)
      create_list(:ticket, 2, event: event, ticket_type: 'even',
        price: 200, reservation_id: reservation.id)
      create_list(:ticket, 3, event: event, ticket_type: 'all_together',
        price: 300, reservation_id: reservation.id)
    end

    it 'returns proper reservation data' do
      expect(described_class.call(reservation.id)).to eq(result)
    end

    context 'tickets without reservation and other reservation in db' do
      let(:user_2) { create :user, email: 'user_2@email.com' }
      let(:event)  { create :event }
      let(:reservation_2) { create :reservation, user: user_2, event: event }

      before do
        # tickets without reservation
        create_list(:ticket, 5, event: event, ticket_type: 'avoid_one', price: 100)
        create_list(:ticket, 2, event: event, ticket_type: 'even', price: 200)
        create_list(:ticket, 3, event: event, ticket_type: 'all_together', price: 300)
        # tickets with other reservation
        create_list(:ticket, 5, event: event, ticket_type: 'avoid_one',
          price: 100, reservation_id: reservation_2.id)
        create_list(:ticket, 2, event: event, ticket_type: 'even',
          price: 200, reservation_id: reservation_2.id)
        create_list(:ticket, 3, event: event, ticket_type: 'all_together',
          price: 300, reservation_id: reservation_2.id)
      end

      it 'returns proper reservation data' do
        expect(described_class.call(reservation.id)).to eq(result)
      end
    end
  end
end
