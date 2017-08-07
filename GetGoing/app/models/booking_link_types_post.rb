class BookingLinkTypesPost < ApplicationRecord
  belongs_to :booking_link_type
  belongs_to :post
end
