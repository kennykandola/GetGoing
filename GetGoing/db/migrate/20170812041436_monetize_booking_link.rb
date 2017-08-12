class MonetizeBookingLink < ActiveRecord::Migration[5.1]
  def change
    add_monetize :booking_links, :affiliate_revenue
  end
end
