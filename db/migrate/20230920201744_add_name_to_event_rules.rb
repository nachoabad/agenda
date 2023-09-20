class AddNameToEventRules < ActiveRecord::Migration[7.0]
  def change
    add_column :event_rules, :name, :string
  end
end
