class BookingLink < ActiveRecord::Base
  belongs_to :post

  enum url_type: [:restaurant, :hotel, :airbnb, :rental, :activity, :flight, :tour, :attraction]
end
