# frozen_string_literal: true
# Helper implements notifications string generating
module NotificationsHelper
  def notifiable_link(notification)
    post = notification.notifiable_post
    case notification.action
    when 'new_response'
      link_to "#{notification.actor.first_name} posted a new response in \"#{post.title}\"", post_path(post)
    when 'recommended_link_upvoted'
      link_to "#{notification.actor.first_name} upvoted your recommended link from \"#{post.title}\"", post_path(post)
    when 'new_post_with_matching_place'
      link_to "#{notification.actor.first_name} just posted \"#{post.title}\" with places you have been", post_path(post)
    when 'new_post_with_matching_nearby_place'
      link_to "#{notification.actor.first_name} just posted \"#{post.title}\" with places nearby to locations you have been", post_path(post)
    when 'new_comment_on_response'
      if notification.notifiable.response.comments.order('created_at ASC').first.id == notification.notifiable.id # check if that comment is first
        link_to "#{notification.actor.first_name} commented on your response to \"#{post.title}\"", post_path(post)
      else
        link_to "#{notification.actor.first_name} replied to your comment", post_path(post)
      end
    when 'claims_open'
      link_to "Claim for #{post.title} has just opened", post_path(post)
    when 'claim_expired'
      link_to "Your claim for #{post.title} has expired", post_path(post)
    end
  end
end
