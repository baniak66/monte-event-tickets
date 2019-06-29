# frozen_string_literal: true

module Serializers
  class EventTickets
    def initialize(event, tickets_array)
      @event         = event
      @tickets_array = tickets_array
    end

    def serialize
      {
        id:      event.id,
        name:    event.name,
        date:    event.date.to_i,
        tickets: event_tickets
      }
    end

    private

    attr_reader :event, :tickets_array

    # :reek:FeatureEnvy
    def event_tickets
      tickets_array.map do |ticket_hash|
        ticket_hash.symbolize_keys!
        { ticket_hash[:type].to_sym => ticket_hash.slice(:quantity, :price) }
      end
    end
  end
end
