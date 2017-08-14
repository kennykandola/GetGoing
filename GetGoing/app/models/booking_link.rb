class BookingLink < ApplicationRecord
  belongs_to :post, touch: true # touch allows to track the latest activity on the post with updated_at
  belongs_to :response

  has_many :votes, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :activities, as: :actionable, dependent: :destroy

  belongs_to :booking_link_type

  monetize :affiliate_revenue_cents

  enum url_type: [:restaurant, :hotel, :airbnb, :rental, :activity, :flight, :tour, :attraction]
end
