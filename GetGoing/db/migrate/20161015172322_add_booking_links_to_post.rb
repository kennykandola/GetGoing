class AddBookingLinksToPost < ActiveRecord::Migration
  def change
    add_column :posts, :booking_links, :string
  end
end
