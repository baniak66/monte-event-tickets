# frozen_string_literal: true

module Serializers
  class Reservation
    def initialize(reservation_data)
      @reservation_data = reservation_data
    end

    def serialize
      reservation_data
        .symbolize_keys!
        .slice(:reservation_id, :event_name, :tickets_amount)
        .merge(event_date)
        .merge(reservation_tickets)
    end

    private

    attr_reader :reservation_data

    def event_date
      {
        event_date: Time.parse(reservation_data.fetch(:event_date)).to_i
      }
    end

    def reservation_tickets
      {
        tickets: Oj.load(reservation_data.fetch(:tickets_quantity))
      }
    end
  end
end
