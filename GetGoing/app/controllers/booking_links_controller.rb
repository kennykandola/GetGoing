class BookingLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking_link
  before_action :set_post
  before_action :set_bl_voting_service, only: [:upvote, :downvote]

  def upvote
    authorize @booking_link
    @bl_voting_service.upvote
    NotificationService.new(actor: current_user,
                            notifiable: @booking_link,
                            recipient: @booking_link.response.user).recommended_link_upvoted
    set_structured_booking_links
    respond_to :js
  end

  def downvote
    authorize @booking_link
    @bl_voting_service.downvote
    set_structured_booking_links
    respond_to :js # 'Remove the link?' modal will still appear even if the link was already downvoted earlier and downvoting is ignored now
  end

  def destroy
    authorize @booking_link
    if @booking_link.destroy
      UserScoreService.new(user: @booking_link.response.user).update_score('remove')
    end
    set_structured_booking_links
    respond_to :js
  end

  private

  def set_booking_link
    @booking_link = BookingLink.find(params[:id])
  end

  def set_bl_voting_service
    @bl_voting_service = BookingLinkVotingService.new(user: current_user,
                                                      booking_link: @booking_link)
  end

  def set_post
    @post = @booking_link.post
  end

  def set_structured_booking_links
    @structured_booking_links = BookingLinksService.new(post: @post)
                                                   .structured_booking_links
  end
end
