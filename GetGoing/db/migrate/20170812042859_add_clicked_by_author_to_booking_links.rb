class AddClickedByAuthorToBookingLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_links, :clicked_by_author, :boolean, default: false
    add_column :booking_links, :clicked_by_author_at, :datetime
  end
end
