class RemoveUrlTypeFromBookingLink < ActiveRecord::Migration[5.1]
  def change
    remove_column :booking_links, :url_type, :integer
  end
end
