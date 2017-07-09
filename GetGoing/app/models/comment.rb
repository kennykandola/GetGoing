class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :response, touch: true

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true

  attr_accessor :discussion_privacy
end
