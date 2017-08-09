class AddTitleToBookingLink < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_links, :title, :string
  end
end
