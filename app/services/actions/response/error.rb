# frozen_string_literal: true

module Actions
  module Response
    class Error < Actions::Response::Base
      def success?
        false
      end
    end
  end
end
