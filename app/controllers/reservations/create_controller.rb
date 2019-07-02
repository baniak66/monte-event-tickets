# frozen_string_literal: true

module Reservations
  class CreateController < BaseActionController
    private

    def action
      ::Actions::CreateReservation.new(reservation_params)
    end

    def reservation_params
      {
        user:             current_user,
        event_id:         params[:event_id],
        tickets_quantity: {
          even:         params[:even],
          all_together: params[:all_together],
          avoid_one:    params[:avoid_one]
        }
      }
    end
  end
end
