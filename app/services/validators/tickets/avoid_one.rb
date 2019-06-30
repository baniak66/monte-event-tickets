# frozen_string_literal: true

module Validators
  module Tickets
    class AvoidOne < Validators::Tickets::Base
      TICKET_TYPE = Ticket::TICKET_TYPES.fetch(:avoid_one)

      private

      def validate_type
        return [] unless (available - reserved) == 1
        ["You have to add one more 'avoid_one' ticket to complete reservation"]
      end
    end
  end
end
