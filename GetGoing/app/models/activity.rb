class Activity < ApplicationRecord
  belongs_to :actor, class_name: 'User'
  belongs_to :actionable, polymorphic: true

  enum action: %i[new_post new_response new_public_comment upvoted_link link_was_upvoted]
end
