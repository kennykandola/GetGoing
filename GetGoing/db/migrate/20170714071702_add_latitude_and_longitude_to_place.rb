class AddLatitudeAndLongitudeToPlace < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :latitude, :float, index: true
    add_column :places, :longitude, :float, index: true
  end
end
