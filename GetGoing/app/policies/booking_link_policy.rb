class BookingLinkPolicy < ApplicationPolicy
  attr_reader :user, :booking_link

  def initialize(user, booking_link)
    @user = user
    @booking_link = booking_link
    @bl_voting_service = BookingLinkVotingService.new(user: @user,
                                                      booking_link: @booking_link)
  end

  def upvote?
    @user && (@user.owns_post?(@booking_link.post) || @booking_link.post.invited?(@user)) &&
      !@bl_voting_service.upvoted?
  end

  def downvote?
    @user && (@user.owns_post?(@booking_link.post) || @booking_link.post.invited?(@user) || @user.moderator? || @user.admin?)
  end

  def destroy?
    @user && (@user.owns_post?(@booking_link.post) || @user.moderator? || @user.admin?)
  end

  def index?
    @user && (@user.moderator? || @user.admin?)
  end

  def click_by_author?
    @user && @user.owns_post?(@booking_link.post)
  end

  def track_click?
    click_by_author?
  end

  def update_affiliate_revenue?
    @user && (@user.moderator? || @user.admin?)
  end

  def edit_affiliate_revenue?
    @user && (@user.moderator? || @user.admin?)
  end
end
