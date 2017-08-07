class CreateBookingLinkTypesPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_link_types_posts do |t|
      t.belongs_to :booking_link_type, foreign_key: true, index: true
      t.belongs_to :post, foreign_key: true, index: true

      t.timestamps
    end

    add_index :booking_link_types_posts, [:booking_link_type_id, :post_id],
              unique: true, name: :index_booking_link_types_posts
  end
end
