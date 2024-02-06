class AddServiceTypeToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :service_type, :string
  end
end
