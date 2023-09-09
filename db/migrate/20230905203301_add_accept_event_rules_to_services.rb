class AddAcceptEventRulesToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :accepts_event_rules, :boolean, default: false
  end
end
