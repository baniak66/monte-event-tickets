class AddStateToReservations < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE reservation_state AS ENUM ('initialized', 'paid', 'canceled');
    SQL

    add_column :reservations, :state, :reservation_state, default: 'initialized'
  end

  def down
    remove_column :reservations, :state

    execute <<-SQL
      DROP TYPE reservation_state;
    SQL
  end
end
