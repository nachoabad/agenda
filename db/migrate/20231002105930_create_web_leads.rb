class CreateWebLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :web_leads do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end
