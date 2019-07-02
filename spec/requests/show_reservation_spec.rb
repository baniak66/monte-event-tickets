# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show reservation', type: :request do
  context 'logged user' do
    include_context 'user_token_authentication'

    let(:event)       { create :event }
    let(:reservation) { create :reservation, event: event, user: user }

    before do
      serializer = instance_double('::Serializers::Reservation')
      allow(::Serializers::Reservation).to receive(:new).and_return(serializer)
      allow(serializer).to receive(:serialize).and_return(serialized: 'reservation')
    end

    it 'responds with 200' do
      get reservations_show_path(reservation.id), headers: user_auth_headers
      expect(response).to have_http_status :ok
    end

    it 'responds with proper json data' do
      get reservations_show_path(reservation.id), headers: user_auth_headers
      expect(Oj.load(response.body)).to eq('serialized' => 'reservation')
    end
  end

  context 'integration test' do
    include_context 'user_token_authentication'

    let(:event) { create :event }
    let(:reservation) { create :reservation, user: user, event: event }

    it 'retruns proper json data' do
      create(:ticket, event: event, ticket_type: 'avoid_one', price: 100, reservation_id: reservation.id)

      get reservations_show_path(reservation.id), headers: user_auth_headers
      expect(Oj.load(response.body)).to eq(
        "event_date"     => event.date.to_i,
        "event_name"     => event.name,
        "reservation_id" => reservation.id,
        "tickets"        => [{ "quantity" => 1, "type" => "avoid_one" }],
        "tickets_amount" => 100,
        "paid_amount"    => 0
      )
    end
  end

  context 'not logged user' do
    it 'responds with 401' do
      get reservations_show_path(1)
      expect(response).to have_http_status 401
    end
  end
end
