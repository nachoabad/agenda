class CreateSlotRules < ActiveRecord::Migration[7.0]
  def change
    create_table :slot_rules do |t|
      t.integer :status, default: 0
      t.string :time
      t.integer :wday
      t.references :service, null: false, foreign_key: true
      # TODO: add time index scope to user wday?

      t.timestamps
    end
  end
end
