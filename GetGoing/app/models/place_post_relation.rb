class PlacePostRelation < ApplicationRecord
  belongs_to :post
  belongs_to :place

  validates :post_id, uniqueness: { scope: [:place_id] }
end
