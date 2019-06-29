class CreateTickets < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE ticket_type AS ENUM ('even', 'all_together', 'avoid_one');
    SQL

    create_table :tickets do |t|
      t.references :event, foreign_key: true, null: false
      t.references :reservation, index: false
      t.integer :price, null: false
      t.column :ticket_type, "ticket_type", null: false

      t.timestamps
    end
  end

  def down
    drop_table :tickets

    execute <<-SQL
      DROP TYPE ticket_type;
    SQL
  end
end
