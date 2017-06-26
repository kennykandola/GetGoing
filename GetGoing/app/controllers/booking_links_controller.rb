class BookingLinksController < ApplicationController
  before_action :set_booking_link
  before_action :set_post

  def upvote
    @booking_link.upvote(current_user)
    respond_to :js
  end

  def downvote
    @booking_link.downvote(current_user)
    respond_to :js
  end

  def destroy
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
