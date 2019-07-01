# frozen_string_literal: true

module Reservations
  class ShowController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: Oj.dump(serialized_reservation, mode: :rails)
    end

    private

    def serialized_reservation
      ::Serializers::Reservation.new(reservation_data).serialize
    end

    def reservation_data
      ::Repository::ReservationTickets.call(params[:id])
    end
  end
end
