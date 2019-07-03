# frozen_string_literal: true

class ReleaseReservationJob < ApplicationJob
  queue_as :default

  # :reek:UtilityFunction
  def perform(reservation_id)
    payment = Payment.find_by(reservation_id: reservation_id)
    return if payment

    ActiveRecord::Base.transaction do
      Ticket.where(reservation_id: reservation_id).update(reservation_id: nil)
      Reservation.find_by(id: reservation_id).destroy
    end
  end
end
