class MatchingPlacesSuggestionJob < ApplicationJob
  queue_as :default

  def perform(post)
    matching_suggestions_service = MatchingSuggestionsService.new(post_id: post.id)
    matching_suggestions_service.find_users
    direct_users = matching_suggestions_service.direct_users
    nearby_users = matching_suggestions_service.nearby_users
    direct_users.uniq.each do |user|
      unless Notification.where(recipient: user, actor: post.owner, notifiable: post,
                                action: 'new_post_with_matching_place').present?
             PostsMailer.matching_destination(post, user).deliver_later
             NotificationService.new(recipient: user, notifiable: post,
                              actor: post.owner).new_post_with_matching_place
      end
    end

    nearby_users.uniq.each do |user|
      unless Notification.where(recipient: user, actor: post.owner, notifiable: post,
                                action: 'new_post_with_matching_nearby_place').present?
             PostsMailer.matching_destination(post, user).deliver_later
             NotificationService.new(recipient: user, notifiable: post,
                                     actor: post.owner).new_post_with_matching_nearby_place
      end
    end
  end
end
