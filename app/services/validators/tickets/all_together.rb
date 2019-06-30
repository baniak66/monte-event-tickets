# frozen_string_literal: true

module Validators
  module Tickets
    class AllTogether < Validators::Tickets::Base
      TICKET_TYPE = Ticket::TICKET_TYPES.fetch(:all_together)

      private

      def validate_type
        return [] if reserved == available
        ["You have to reserve all tickets of that type"]
      end
    end
  end
end
