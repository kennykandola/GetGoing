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
    deviver_new_response(@post.owner)
    @post.invited_users.each do |invited_user|
      deviver_new_response(invited_user)
    end
  end

  def deviver_new_response(recipient)
    @recipient = recipient
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
    responder = @notifiable.response.user
    deliver_new_comment_on_response(@post.owner) unless @post.owner == @actor
    deliver_new_comment_on_response(responder) unless responder == @actor
    @post.invited_users.each do |invited_user|
      deliver_new_comment_on_response(invited_user) unless invited_user == @actor
    end
  end

  def deliver_new_comment_on_response(recipient)
    @recipient = recipient
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

  def claim_expired
    @notifiable = @post
    @actor = @post.owner
    notify('claim_expired')
  end

  def invited_to_post
    @notifiable = @post
    notify('invited_to_post')
  end

  def accepted_invitation
    @notifiable = @post
    notify('accepted_invitation')
  end
end
