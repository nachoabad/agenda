class RemoveDefaultFromUsersTimezone < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :time_zone, from: "UTC", to: nil
  end
end
