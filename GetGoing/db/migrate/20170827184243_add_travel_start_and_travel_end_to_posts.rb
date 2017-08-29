class AddTravelStartAndTravelEndToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :travel_start, :date
    add_column :posts, :travel_end, :date
  end
end
