class CreateEventRules < ActiveRecord::Migration[7.0]
  def change
    create_table :event_rules do |t|
      t.date :start_date
      t.integer :recurrence
      t.references :slot_rule, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :event_rules, :status
  end
end
