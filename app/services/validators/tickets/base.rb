# frozen_string_literal: true

module Validators
  module Tickets
    class Base
      def initialize(reserved, available)
        @reserved  = reserved.to_i
        @available = available.to_i
      end

      def validate
        return over_available_error if reserved_over_available?
        validate_type
      end

      private

      attr_reader :reserved, :available

      def reserved_over_available?
        reserved > available
      end

      def validate_type
        raise NotImplementedError
      end

      def over_available_error
        ["We haven't got enough '#{self.class::TICKET_TYPE}' tickets available"]
      end
    end
  end
end
