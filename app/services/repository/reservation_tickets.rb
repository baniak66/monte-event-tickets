# frozen_string_literal: true

module Repository
  class ReservationTickets
    class << self
      def call(reservation_id)
        ActiveRecord::Base.connection.execute(
          ActiveRecord::Base.sanitize_sql_array([query_string, reservation_id: reservation_id])
        ).to_a.first
      end

      private

      def query_string
        <<-SQL
          SELECT
            r.id AS reservation_id,
            e.name AS event_name,
            e.date AS event_date,
            tickets_reserved.quantity AS tickets_quantity,
            reserved_tickets_amount.summed AS tickets_amount,
            paid.amount as paid_amount
          FROM reservations r
          JOIN events e ON e.id = r.event_id
          LEFT JOIN LATERAL
            (
              SELECT array_to_json(array_agg(row.*)) AS quantity
              FROM (
                SELECT COUNT(t.id) AS quantity, t.ticket_type AS type
                FROM tickets t
                WHERE t.reservation_id = :reservation_id
                GROUP BY t.ticket_type
              ) row
            ) AS tickets_reserved ON true
          LEFT JOIN LATERAL
            (
              SELECT SUM(t.price) AS summed
              FROM tickets t
              WHERE t.reservation_id = :reservation_id
            ) AS reserved_tickets_amount ON true
          LEFT JOIN LATERAL
            (
              SELECT COALESCE(
                (SELECT amount FROM payments p WHERE p.reservation_id = :reservation_id), 0) AS amount
            ) AS paid ON true
          WHERE r.id = :reservation_id
        SQL
      end
    end
  end
end
