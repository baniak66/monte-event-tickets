class AddPaymentTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :payment_token, :string, default: ""
  end
end
