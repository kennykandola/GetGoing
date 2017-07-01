class BookingLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking_link
  before_action :set_post

  def upvote
    authorize @booking_link
    @booking_link.upvote(current_user)
    NotificationService.new(actor: current_user,
                            notifiable: @booking_link,
                            recipient: @booking_link.response.user).recommended_link_upvoted
    respond_to :js
  end

  def downvote
    authorize @booking_link
    @booking_link.downvote(current_user) unless @booking_link.downvoted_by?(current_user)
    respond_to :js # 'Remove the link?' modal will still appear even if the link was already downvoted earlier and downvoting is ignored now
  end

  def destroy
    authorize @booking_link
    @booking_link.destroy
    respond_to :js
  end

  private

  def set_booking_link
    @booking_link = BookingLink.find(params[:id])
  end

  def set_post
    @post = @booking_link.post
  end
end
