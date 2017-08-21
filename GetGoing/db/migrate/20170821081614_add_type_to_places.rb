class AddTypeToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :place_type, :integer, default: 0
  end
end
