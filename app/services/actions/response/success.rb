# frozen_string_literal: true

module Actions
  module Response
    class Success < Actions::Response::Base
      def success?
        true
      end
    end
  end
end
