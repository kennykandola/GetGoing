class AddAccomodationsToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :amenities, :text, array:true, default: []
    add_column :posts, :location_from, :string
    add_column :posts, :location_distance, :float
    add_column :posts, :neighborhoods, :string
    add_column :posts, :traveler_rating, :integer
    add_column :posts, :accomodation_style, :text, array:true, default: []
    add_column :posts, :min_accomodation_price, :integer
    add_column :posts, :max_accomodation_price, :integer
  end
end
