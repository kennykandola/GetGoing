class BookingLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking_link, only: [:upvote, :downvote, :destroy, :click_by_author, :edit_affiliate_revenue, :update_affiliate_revenue]
  before_action :set_post, only: [:upvote, :downvote, :destroy, :click_by_author]
  before_action :set_booking_links_service, only: [:upvote, :downvote, :destroy, :click_by_author]
  before_action :set_bl_voting_service, only: [:upvote, :downvote]

  def index
    @booking_links = sorted_and_paginated_booking_links
    authorize @booking_links
    @booking_links = @booking_links.decorate
  end

  def click_by_author
    authorize @booking_link
    head :ok if @booking_links_service.click_by_author
  end


  def edit_affiliate_revenue
    authorize @booking_link
    @booking_link = @booking_link.decorate
    respond_to :js
  end

  def update_affiliate_revenue
    authorize @booking_link
    affiliate_revenue_cents = params[:booking_link][:affiliate_revenue_cents].gsub(/[^0-9]/, '')
    if @booking_link.update(affiliate_revenue_cents: affiliate_revenue_cents)
      @booking_links = sorted_and_paginated_booking_links.decorate
      respond_to :js
    end
  end

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

  def set_booking_links_service
    @booking_links_service = BookingLinksService.new(post: @post, booking_link: @booking_link)
  end

  def set_structured_booking_links
    @structured_booking_links = @booking_links_service.structured_booking_links
  end

  def sorted_and_paginated_booking_links
    BookingLink.all.order(created_at: :desc).paginate(page: params[:page], per_page: 30)
  end
end
