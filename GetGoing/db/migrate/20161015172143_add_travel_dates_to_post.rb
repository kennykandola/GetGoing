class AddTravelDatesToPost < ActiveRecord::Migration
  def change
    add_column :posts, :travel_dates, :string
  end
end
