class AddCurrencyToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :currency, :integer
    add_index :payments, :currency
  end
end
