# frozen_string_literal: true
# This class handles notifying users about events and actions inside of system
class NotificationService
  def initialize(params)
    @actor = params[:actor]
    @notifiable = params[:notifiable]
    @recipient = params[:recipient]
    @post = params[:post]
  end

  def notify(action)
    Notification.create(recipient_id: @recipient.id, actor_id: @actor.id, notifiable: @notifiable, action: action)
  end

  def new_response
    @recipient = @post.owner
    notify('new_response')
  end

  def recommended_link_upvoted
    notify('recommended_link_upvoted')
  end

  def new_post_with_matching_place
    notify('new_post_with_matching_place')
  end

  def new_post_with_matching_nearby_place
    notify('new_post_with_matching_nearby_place')
  end

  def new_comment_on_response
    if @actor == @notifiable.response.user # @notifiable in this case is the comment object
      @recipient = @post.owner
    elsif @actor == @post.owner
      @recipient = @notifiable.response.user
    end
    notify('new_comment_on_response')
    ResponsesMailer.new_comment_email(@notifiable.response, @recipient).deliver_later
  end

  def claims_open
    @notifiable = @post
    @actor = @post.owner
    @post.claims.where(status: 'waitlisted').each do |claim|
      @recipient = claim.user
      notify('claims_open')
    end
  end
end
