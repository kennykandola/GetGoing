class AddTravelStyleToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :travel_style, :string
  end
end
