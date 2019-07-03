# frozen_string_literal: true

module Actions
  class CreateReservation
    def initialize(user:, event_id:, tickets_quantity:)
      @user             = user
      @event_id         = event_id
      @tickets_quantity = tickets_quantity
    end

    def call
      return validation_error_response unless validation_errors.empty?
      return success_callback if create_reservation
      Actions::Response::Error.new(result: { errors: 'Error occured' })
    end

    private

    attr_reader :user, :event_id, :tickets_quantity, :reservation

    def create_reservation
      ActiveRecord::Base.transaction do
        return true if create_reservation_record && assaign_tickets_to_reservation
        raise ActiveRecord::Rollback
      end
    end

    def validation_errors
      @validation_errors ||= ::Validators::ReservationTicketsQuantity
                             .new(tickets_quantity, available_tickets)
                             .validate
    end

    def create_reservation_record
      @reservation = Reservation.create(event_id: event_id, user: user)
    end

    def assaign_tickets_to_reservation
      tickets_quantity.each do |type, quantity|
        Ticket
          .where(
            ticket_type: Ticket::TICKET_TYPES.fetch(type),
            event_id:    event_id
          )
          .limit(quantity)
          .update(reservation_id: reservation.id)
      end
    end

    def validation_error_response
      Actions::Response::Error.new(
        result: {
          errors: validation_errors.join('. ')
        }
      )
    end

    # fetch data just before validate and create reservation
    # to ensure that we operate on updated values
    def available_tickets
      tickets = ::Repository::EventAvailableTickets.call(event_id)
      tickets.group_by { |ticket_hash| ticket_hash['type'] }
    end

    def success_callback
      ReleaseReservationJob
        .set(wait: Reservation::NOT_PAID_RELEASE_TIME.minutes)
        .perform_later(reservation.id)
      Actions::Response::Success.new
    end
  end
end
