# frozen_string_literal: true

module Reservations
  class CreateController < ApplicationController
    before_action :authenticate_user!

    def create
      action_response = create_reservation
      if action_response.success?
        head :ok
      else
        render json: Oj.dump(action_response.result, mode: :rails), status: :unprocessable_entity
      end
    end

    private

    def create_reservation
      ::Actions::CreateReservation.new(reservation_params).call
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
