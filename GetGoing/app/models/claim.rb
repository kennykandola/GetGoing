class Claim < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :user_id, uniqueness: { scope: :post_id, message: 'can claim post only once' }

  enum status: %i[accepted responded expired waitlisted canceled response_deleted]

  after_save :update_post_availibility
  after_destroy :update_post_availibility

  def update_post_availibility
    ClaimsService.new(post: self.post).update_post_availibility
  end
end
