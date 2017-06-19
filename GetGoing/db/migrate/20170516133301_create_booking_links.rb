class CreateBookingLinks < ActiveRecord::Migration
  def change
    create_table :booking_links do |t|
      t.string :url

      # enum value which represents type of booking link, e.g. restaurant, hotel, etc.
      t.integer :url_type

      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
