class BookingLink < ApplicationRecord
  belongs_to :post, touch: true # touch allows to track the latest activity on the post with updated_at
  belongs_to :response

  has_many :votes, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  enum url_type: [:restaurant, :hotel, :airbnb, :rental, :activity, :flight, :tour, :attraction]

  def downvote(user)
    VotingService.new(user: user, booking_link: self).downvote
  end

  def upvoted_by?(user)
    upvotes.where(user_id: user).present?
  end

  def downvoted_by?(user)
    downvotes.where(user_id: user).present?
  end

  def upvotes
    votes.where(value: 1)
  end

  def downvotes
    votes.where(value: -1)
  end

  def shortened_url
    return url if url.length < 40

    url[0, 40].to_s + '...' # shortened version of url for rendering in case of long urls
  end
end
