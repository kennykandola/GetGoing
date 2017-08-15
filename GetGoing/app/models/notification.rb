class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  enum action: %i[new_response recommended_link_upvoted new_post_with_matching_place
                  new_comment_on_response new_post_with_matching_nearby_place
                  claims_open claim_expired]

  after_commit -> { NotificationRelayJob.perform_later(recipient_id) }, on: [:create, :update]

  def self.system_actions
    %[claims_open claim_expired]
  end

  def notifiable_post
    if notifiable_type == 'Post'
      notifiable
    elsif ['Response', 'BookingLink'].include? notifiable_type
      notifiable.post
    elsif notifiable_type == 'Comment'
      notifiable.response.post
    end
  end
end
