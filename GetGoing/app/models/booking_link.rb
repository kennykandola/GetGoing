class BookingLink < ApplicationRecord
  belongs_to :post
  belongs_to :response
  has_many :votes, dependent: :destroy

  enum url_type: [:restaurant, :hotel, :airbnb, :rental, :activity, :flight, :tour, :attraction]

  def upvote(user)
    if downvoted_by?(user)
      downvotes.where(user_id: user).first.update(value: 1)
    else
      vote = votes.new(booking_link: self, user: user, value: 1)
      vote.save
    end
    self.cached_votes_up = votes.where(value: 1).count
    self.cached_votes_down = votes.where(value: -1).count
    save
  end

  def downvote(user)
    if upvoted_by?(user)
      upvotes.where(user_id: user).first.update(value: -1)
    else
      vote = votes.new(booking_link: self, user: user, value: -1)
      vote.save
    end
    self.cached_votes_up = votes.where(value: 1).count
    self.cached_votes_down = votes.where(value: -1).count
    save
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
