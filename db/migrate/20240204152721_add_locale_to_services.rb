class AddLocaleToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :locale, :string, default: 'es'
  end
end
