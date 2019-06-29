# frozen_string_literal: true

module Repository
  class EventAvailableTickets
    class << self
      def call(event_id)
        ActiveRecord::Base.connection.execute(
          ActiveRecord::Base.sanitize_sql_array([query_string, event_id: event_id])
        ).to_a
      end

      private

      def query_string
        <<-SQL
          SELECT count(e.id) AS quantity, t.ticket_type AS type, t.price
          FROM events e
          JOIN tickets t ON t.event_id = e.id
          WHERE t.reservation_id is NULL AND e.id = :event_id
          GROUP BY t.ticket_type, t.price
        SQL
      end
    end
  end
end
