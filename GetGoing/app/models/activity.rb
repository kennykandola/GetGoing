class Activity < ApplicationRecord
  belongs_to :actor, class_name: 'User'
  belongs_to :actionable, polymorphic: true

  enum action: %i[new_post new_response new_public_comment upvoted_link link_was_upvoted]

  def actionable_post
    if actionable_type == 'Post'
      actionable
    elsif %w[Response BookingLink].include? actionable_type
      actionable.post
    elsif notifiable_type == 'Comment'
      actionable.response.post
    end
  end
end
