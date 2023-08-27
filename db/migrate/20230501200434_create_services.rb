class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :time_zone, null: false, default: "UTC"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
