class AddIndexToPlacesGooglePlaceId < ActiveRecord::Migration[5.1]
  def change
    add_index :places, :google_place_id, unique: true
  end
end
