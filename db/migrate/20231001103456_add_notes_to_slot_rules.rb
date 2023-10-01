class AddNotesToSlotRules < ActiveRecord::Migration[7.0]
  def change
    add_column :slot_rules, :short_note, :string
    add_column :slot_rules, :long_note, :string
  end
end
