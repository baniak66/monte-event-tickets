# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serializers::Reservation do
  let(:reservation_data) do
    {
      "reservation_id"   => 1,
      "event_name"       => "Awesome Event",
      "event_date"       => "2019-07-02 12:00:00",
      "tickets_amount"   => 1800,
      "paid_amount"      => 1800,
      "tickets_quantity" => [
        { "quantity" => 2, "type" => "even" },
        { "quantity" => 3, "type" => "all_together" },
        { "quantity" => 5, "type" => "avoid_one" }
      ].to_json
    }
  end
  let(:instance) { described_class.new(reservation_data) }

  describe '.serialize' do
    it 'returns serialized reservation with tickets' do
      expect(instance.serialize).to eq(
        event_date:     1562068800,
        event_name:     "Awesome Event",
        reservation_id: 1,
        tickets:        [
          { "quantity" => 2, "type" => "even" },
          { "quantity" => 3, "type" => "all_together" },
          { "quantity" => 5, "type" => "avoid_one" }
        ],
        tickets_amount: 1800,
        paid_amount:    1800
      )
    end
  end
end
