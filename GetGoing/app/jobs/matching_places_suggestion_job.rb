class MatchingPlacesSuggestionJob < ApplicationJob
  queue_as :default

  def perform(post)
    author_id = post.user.id
    users_to_notify = []
    post.places.each do |place|
      place.users.each do |user|
        users_to_notify << user unless user.id == author_id
      end
    end
    users_to_notify.uniq.each do |user|
      PostsMailer.suggest_post(post, user).deliver_later
      NotificationService.new(recipient: user, notifiable: post,
                              actor: post.user).new_post_with_matching_place
    end
  end
end
