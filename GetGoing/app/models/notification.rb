class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  enum action: [:new_response, :recommended_link_upvoted, :new_post_with_matching_place]

  after_commit -> { NotificationRelayJob.perform_later(self.recipient) }
end
