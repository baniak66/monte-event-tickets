class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :reservation, foreign_key: true, null: false, index: true
      t.integer :amount, null: false
      t.string :currency, default: "EUR"

      t.timestamps
    end
  end
end
