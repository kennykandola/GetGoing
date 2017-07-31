class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :country
      t.string :google_place_id

      t.timestamps
    end
  end
end
