class AddSettingsToService < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :settings, :json, default: {}
  end
end
