# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serializers::EventTickets do
  let(:event) { create :event }
  let(:tickets_array) do
    [
      {
        "quantity" => 12,
        "type"     => "even",
        "price"    => 900
      },
      {
        "quantity" => 43,
        "type"     => "all_together",
        "price"    => 1000
      },
      {
        "quantity" => 15,
        "type"     => "avoid_one",
        "price"    => 700
      }
    ]
  end
  let(:instance) { described_class.new(event, tickets_array) }

  describe '.serialize' do
    it 'returns serialized event with tickets' do
      expect(instance.serialize).to eq(
        id:      event.id,
        name:    event.name,
        date:    event.date.to_i,
        tickets: [
          {
            even: {
              price:    900,
              quantity: 12
            }
          },
          {
            all_together: {
              price:    1000,
              quantity: 43
            }
          },
          {
            avoid_one: {
              price:    700,
              quantity: 15
            }
          }
        ]
      )
    end
  end
end
