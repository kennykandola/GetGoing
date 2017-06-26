class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :booking_link

  validates :user_id, uniqueness: { scope: :booking_link_id,
                                    message: 'user can have only one vote per booking link' }
end
