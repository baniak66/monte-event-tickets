# frozen_string_literal: true

# :reek:UtilityFunction
class ReleaseReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find_by(id: reservation_id)
    return if reservation.paid?
    cancel_reservation(reservation)
  end

  private

  def cancel_reservation(reservation)
    ActiveRecord::Base.transaction do
      Ticket.where(reservation_id: reservation.id).update(reservation_id: nil)
      reservation.update!(state: Reservation::STATES.fetch(:canceled))
    end
  end
end
