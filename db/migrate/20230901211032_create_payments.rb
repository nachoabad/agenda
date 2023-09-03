class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :status, default: 0
      t.date :date
      t.decimal :amount
      t.string :reference
      t.text :comments
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
