# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::EventAvailableTickets do
  let(:event) { create :event }

  before do
    create_list(:ticket, 5, event: event, ticket_type: 'avoid_one', price: 100)
    create_list(:ticket, 2, event: event, ticket_type: 'even', price: 200)
    create_list(:ticket, 3, event: event, ticket_type: 'all_together', price: 300)
  end

  describe 'self.call' do
    it 'returns event tickets data' do
      expect(described_class.call(event.id)).to eq(
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
      )
    end
  end
end
