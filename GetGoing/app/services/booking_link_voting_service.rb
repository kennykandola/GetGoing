# The service class handles voting logic for user
class BookingLinkVotingService
  def initialize(params)
    @user = params[:user]
    @booking_link = params[:booking_link]
  end

  def upvote
    if downvoted?
      downvotes.where(user_id: @user).first.update(value: 1)
    else
      vote = @booking_link.votes.new(booking_link: @booking_link, user: @user, value: 1)
      vote.save
    end
    update_cached_votes
    UserScoreService.new(user: @booking_link.response.user).update_score('upvote')
    track_activity
  end

  def downvote
    if upvoted?
      upvotes.where(user_id: @user).first.update(value: -1)
    else
      vote = @booking_link.votes.new(booking_link: @booking_link, user: @user, value: -1)
      vote.save
    end
    update_cached_votes
    UserScoreService.new(user: @booking_link.response.user).update_score('downvote')
  end

  def update_cached_votes
    @booking_link.cached_votes_up = @booking_link.votes.where(value: 1).count
    @booking_link.cached_votes_down = @booking_link.votes.where(value: -1).count
    @booking_link.save
  end

  def upvoted?
    upvotes.where(user_id: @user).present?
  end

  def downvoted?
    downvotes.where(user_id: @user).present?
  end

  def upvotes
    @booking_link.votes.where(value: 1)
  end

  def downvotes
    @booking_link.votes.where(value: -1)
  end

  def track_activity
    Activity.create(actor: @user, actionable: @booking_link, action: 'upvoted_link')
    Activity.create(actor: @booking_link.response.user, actionable: @booking_link, action: 'link_was_upvoted')
  end
end
