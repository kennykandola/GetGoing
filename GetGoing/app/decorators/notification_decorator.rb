class NotificationDecorator < ApplicationDecorator
  delegate_all
  decorates_association :actor

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def render_notifications
    case action
    when 'new_response'
      action = 'posted a response in'
      h.render partial: 'notifications/notifications/notification_uao', locals: { activity: self, action: action }
    when 'recommended_link_upvoted'
      action = 'upvoted your recommended link from'
      h.render partial: 'notifications/notifications/notification_uao', locals: { activity: self, action: action }
    when 'new_comment_on_response'
      if notification.notifiable.response.comments.order('created_at ASC').first.id == notification.notifiable.id # check if that comment is first
        action = 'commented on your response to'
        h.render partial: 'notifications/notifications/notification_uao', locals: { activity: self, action: action }
      else
        action = 'replied to your comment from'
        h.render partial: 'notifications/notifications/notification_uao', locals: { activity: self, action: action }
      end

    when 'new_post_with_matching_place'
      action = 'posted'
      extra = 'with places you have been'
      h.render partial: 'notifications/notifications/notification_uaoe', locals: { activity: self, action: action, extra: extra }
    when 'new_post_with_matching_nearby_place'
      action = 'posted'
      extra = 'with places nearby to locations you have been'
      h.render partial: 'notifications/notifications/notification_uaoe', locals: { activity: self, action: action, extra: extra }

    when 'claims_open'
      action = 'has opened'
      extra = 'Claim for '
      h.render partial: 'notifications/notifications/notification_eoa', locals: { activity: self, action: action, extra: extra }
    when 'claim_expired'
      action = 'has expired'
      extra = 'Your claim for '
      h.render partial: 'notifications/notifications/notification_eoa', locals: { activity: self, action: action, extra: extra }
    end
  end

  def icon
    if Notification.system_actions.include? action
      h.icon "cogs", class: 'system-activity'
    else
      h.link_to h.image_tag(actor.picture_url, height: "35px", class: "img-circle")
    end
  end


end
