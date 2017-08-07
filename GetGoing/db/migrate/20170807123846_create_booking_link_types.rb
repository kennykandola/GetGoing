class CreateBookingLinkTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_link_types do |t|
      t.string :name
      t.string :url_type

      t.timestamps
    end
  end
end
