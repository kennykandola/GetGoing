class BookingLinkType < ApplicationRecord
  has_many :booking_links, dependent: :destroy

  has_many :booking_link_types_posts, dependent: :destroy
  has_many :posts, through: :booking_link_types_posts
end
