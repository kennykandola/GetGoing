class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :response, touch: true

  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :activities, as: :actionable, dependent: :destroy

  validates :body, presence: true

  attr_accessor :discussion_privacy

  after_create :track_activity

  def track_activity
    if response.public_type?
      Activity.create(actor: user,
                      actionable: self,
                      action: 'new_public_comment')
    end
  end
end
