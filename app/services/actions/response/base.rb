# frozen_string_literal: true

module Actions
  module Response
    class Base
      attr_reader :result

      def initialize(result: nil)
        @result = result
      end

      def success?
        raise NotImplementedError
      end
    end
  end
end
