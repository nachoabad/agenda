class AddCommentToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :comment, :text
  end
end
