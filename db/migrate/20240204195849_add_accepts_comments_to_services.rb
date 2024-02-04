class AddAcceptsCommentsToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :accepts_comments, :boolean, default: false
  end
end
