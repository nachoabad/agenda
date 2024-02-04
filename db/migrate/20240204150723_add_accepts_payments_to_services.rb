class AddAcceptsPaymentsToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :accepts_payments, :boolean, default: false
  end
end
