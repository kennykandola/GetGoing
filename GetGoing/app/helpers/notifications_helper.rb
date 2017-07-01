# frozen_string_literal: true
# Helper implements notifications string generating
module NotificationsHelper
  def notifiable_post(notification)
    if notification.notifiable_type = 'Post'
      return notification.notifiable
    elsif ['Response', 'BookingLink'].include? notification.notifiable_type
      return notification.notifiable.post
    end
  end


  def notifiable_link(notification)
    post = notifiable_post(notification)
    case notification.action
    when 'new_response'
      link_to "\"#{post.title}\" got a new response", post_path(post)
    when 'recommended_link_upvoted'
      link_to "Your recommended link from \"#{post}\" has been upvoted", post_path(post)
    when 'new_post_with_matching_place'
      # TODO
    end
  end
end
