class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :response, touch: true

  has_many :notifications, as: :notifiable, dependent: :destroy

  enum discussion_privacy: [:public_type, :private_type]

  validates :body, presence: true
end
