class AddAcceptsSlotNotesToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :accepts_slot_notes, :boolean, default: false
  end
end
