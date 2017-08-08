class BookingLinkPolicy < ApplicationPolicy
  attr_reader :user, :booking_link

  def initialize(user, booking_link)
    @user = user
    @booking_link = booking_link
    @bl_voting_service = BookingLinkVotingService.new(user: @user,
                                                      booking_link: @booking_link)
  end

  def upvote?
    @user && @user.owns_post?(@booking_link.post) &&
      !@bl_voting_service.upvoted?
  end

  def downvote?
    @user && (@user.owns_post?(@booking_link.post) || @user.moderator? || @user.admin?)
  end

  def destroy?
    @user && (@user.owns_post?(@booking_link.post) || @user.moderator? || @user.admin?)
  end
end
