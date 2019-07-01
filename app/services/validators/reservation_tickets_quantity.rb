# frozen_string_literal: true

module Validators
  class ReservationTicketsQuantity
    NO_TICKETS_HASH = [{ 'quantity' => 0 }].freeze

    def initialize(tickets_quantity, available_tickets)
      @tickets_quantity  = tickets_quantity
      @available_tickets = available_tickets
    end

    def validate
      tickets_quantity.map do |type, reserved|
        next unless reserved
        validate_type(type, reserved)
      end.flatten.compact
    end

    private

    attr_reader :tickets_quantity, :available_tickets

    def validate_type(type, reserved)
      available_in_type = available_in_type(type)
      validator_class(type).new(reserved, available_in_type).validate
    end

    # :reek:ControlParameter
    def validator_class(ticket_type)
      case ticket_type
      when :even
        Validators::Tickets::Even
      when :all_together
        Validators::Tickets::AllTogether
      else
        Validators::Tickets::AvoidOne
      end
    end

    def available_in_type(ticket_type)
      available_tickets.fetch(ticket_type.to_s, NO_TICKETS_HASH).first['quantity']
    end
  end
end
