class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.integer :status, default: 0
      t.date :date
      t.references :user, null: false, foreign_key: true
      t.references :slot_rule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
