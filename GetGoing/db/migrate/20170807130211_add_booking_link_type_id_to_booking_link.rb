class AddBookingLinkTypeIdToBookingLink < ActiveRecord::Migration[5.1]
  def change
    add_reference :booking_links, :booking_link_type, foreign_key: true, index: true
  end
end
