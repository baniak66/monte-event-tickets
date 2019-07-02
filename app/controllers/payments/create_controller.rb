# frozen_string_literal: true

module Payments
  class CreateController < ApplicationController
    before_action :authenticate_user!

    def create
      action_response = create_payment.call
      if action_response.success?
        head :ok
      else
        render json: Oj.dump(action_response.result, mode: :rails), status: :unprocessable_entity
      end
    end

    private

    def create_payment
      ::Actions::CreatePayment.new(
        reservation_id: params[:id],
        amount:         params[:amount],
        token:          payment_token
      )
    end

    # I made an assumption that the token might be stored with users data
    # like card number or something like that.
    def payment_token
      current_user.payment_token
    end
  end
end
