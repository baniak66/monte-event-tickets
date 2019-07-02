# frozen_string_literal: true

module Payments
  class CreateController < BaseActionController
    private

    def action
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
