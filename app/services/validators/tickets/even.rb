# frozen_string_literal: true

module Validators
  module Tickets
    class Even < Validators::Tickets::Base
      TICKET_TYPE = Ticket::TICKET_TYPES.fetch(:even)

      private

      def validate_type
        return [] if reserved.even?
        ["You have to reserve even number of tickets"]
      end
    end
  end
end
