# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event) { create :event }
  let(:serializer) { instance_double('::Serializers::EventTickets') }
  let(:seriailzed_event) { { 'serialized' => 'event' } }

  it 'responds with 200' do
    allow(::Serializers::EventTickets).to receive(:new).and_return(serializer)
    expect(serializer).to receive(:serialize).and_return(seriailzed_event)

    get :show, params: { id: event.id }
    expect(response).to have_http_status :ok
  end

  it 'uses proper services to fetch and serialize data' do
    expect(::Repository::EventAvailableTickets).to receive(:call).with(event.id).and_return([])
    expect(::Serializers::EventTickets).to receive(:new).with(event, []).and_return(serializer)
    expect(serializer).to receive(:serialize).and_return(seriailzed_event)

    get :show, params: { id: event.id }
    expect(Oj.load(response.body)).to eq seriailzed_event
  end

  context 'integration test' do
    it 'returns proper json' do
      create_list(:ticket, 5, event: event, ticket_type: 'avoid_one', price: 100)
      create_list(:ticket, 2, event: event, ticket_type: 'even', price: 200)
      create_list(:ticket, 3, event: event, ticket_type: 'all_together', price: 300)

      get :show, params: { id: event.id }
      expect(Oj.load(response.body)).to eq(
        'id'      => event.id,
        'name'    => event.name,
        'date'    => event.date.to_i,
        'tickets' => [
          {
            "even" => {
              "price"    => 200,
              "quantity" => 2
            }
          },
          {
            "all_together" => {
              "price"    => 300,
              "quantity" => 3
            }
          },
          {
            "avoid_one" => {
              "price"    => 100,
              "quantity" => 5
            }
          }
        ]
      )
    end
  end
end
