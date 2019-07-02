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
        .merge(reservation_details)
    end

    private

    attr_reader :reservation_data

    def reservation_details
      {
        event_date:  Time.zone.parse(reservation_data.fetch(:event_date)).to_i,
        tickets:     Oj.load(reservation_data.fetch(:tickets_quantity)),
        paid_amount: reservation_data.fetch(:paid_amount)
      }
    end
  end
end
