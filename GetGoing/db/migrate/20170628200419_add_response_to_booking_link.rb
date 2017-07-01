class AddResponseToBookingLink < ActiveRecord::Migration[5.1]
  def change
    add_reference :booking_links, :response, foreign_key: true
  end
end
