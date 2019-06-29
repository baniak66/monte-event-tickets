# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::EventAvailableTickets do
  describe 'self.call' do
    let(:event)       { create :event }
    let(:event_2)     { create :event }
    let(:user)        { create :user }
    let(:reservation) { create :reservation, user: user, event: event }
    let(:event_available_tickets) do
      [
        {
          "quantity" => 2,
          "type"     => "even",
          "price"    => 200
        },
        {
          "quantity" => 3,
          "type"     => "all_together",
          "price"    => 300
        },
        {
          "quantity" => 5,
          "type"     => "avoid_one",
          "price"    => 100
        }
      ]
    end

    before do
      create_list(:ticket, 5, event: event, ticket_type: 'avoid_one', price: 100)
      create_list(:ticket, 2, event: event, ticket_type: 'even', price: 200)
      create_list(:ticket, 3, event: event, ticket_type: 'all_together', price: 300)
    end

    it 'returns event proper tickets data' do
      expect(described_class.call(event.id)).to eq(event_available_tickets)
    end

    context 'event has reserved tickets' do
      it 'returns event proper tickets data' do
        create_list(
          :ticket, 3, event: event, ticket_type: 'avoid_one', price: 300, reservation_id: reservation.id
        )
        create_list(
          :ticket, 2, event: event, ticket_type: 'even', price: 300, reservation_id: reservation.id
        )

        expect(described_class.call(event.id)).to eq(event_available_tickets)
      end
    end

    context 'another event tickets in db' do
      it 'returns event proper tickets data' do
        create_list(:ticket, 2, event: event_2, ticket_type: 'avoid_one', price: 400)
        create_list(:ticket, 4, event: event_2, ticket_type: 'even', price: 500)
        create_list(:ticket, 3, event: event_2, ticket_type: 'all_together', price: 600)

        expect(described_class.call(event.id)).to eq(event_available_tickets)
      end
    end
  end
end
