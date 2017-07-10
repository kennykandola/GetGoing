class ChangeCountryToAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :places, :country, :address
  end
end
