class AddCityStateCountryToPlace < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :city, :string
    add_column :places, :state, :string
    add_column :places, :country, :string
  end
end
