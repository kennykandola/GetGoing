class AddIsAccommodationToBookingLinkType < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_link_types, :is_accommodation, :boolean, default: false
  end
end
