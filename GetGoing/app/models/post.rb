class Post < ApplicationRecord
  belongs_to :user

  has_many :booking_links
  has_many :responses
  has_many :top_responses
  has_many :claims

  after_save :set_closing_job

  serialize :claimed_users, Array

  validates_presence_of :title

  scope :open, -> { where(status: true) }

  def open?
    status
  end

  def close
    self.status = false
    save
  end

  def set_closing_job
    ClosePostByDeadlineJob.set(wait_until: expired_at + 22.hours + 25.minutes).perform_later(self) if expired_at.present?
  end
end
