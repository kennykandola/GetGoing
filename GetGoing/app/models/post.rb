class Post < ApplicationRecord
  # belongs_to :user
  has_many :booking_links, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :top_responses
  has_many :claims, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :activities, as: :actionable, dependent: :destroy

  has_many :post_users, dependent: :destroy
  has_many :users, through: :post_users

  has_many :place_post_relations, dependent: :destroy
  has_many :places, through: :place_post_relations

  has_many :booking_link_types_posts, dependent: :destroy
  has_many :booking_link_types, through: :booking_link_types_posts

  has_secure_token :invitation_token

  accepts_nested_attributes_for :places
  attr_accessor :main_destinataion_city
  attr_accessor :main_destinataion_country

  after_save :set_closing_job

  # serialize :claimed_users, Array

  validates_presence_of :title

  def owner
    User.where(id: post_users.ownerships.pluck(:user_id)).first
  end

  def invited_users
    User.where(id: post_users.invitations.pluck(:user_id))
  end

  def owner=(user)
    post_users.create(user: user, role: 'owner') unless owner?(user)
  end

  def owner?(user)
    post_users.where(user: user).where(role: 'owner').present?
  end

  def invite_user(user)
    post_users.create(user: user, role: 'invited_user') unless invited?(user)
  end

  def invited?(user)
    post_users.where(user: user).where(role: 'invited_user').present?
  end

  scope :status_open, -> { where(status: true) }

  searchkick # index model with elasticsearch

  def search_data
    {
      title: title,
      who_is_traveling: who_is_traveling,
      body: body,
      budget: budget,
      destination: destination,
      structured: structured,
      already_booked: already_booked,
      places_city: places.map(&:city),
      places_country: places.map(&:country),
      places_state: places.map(&:state)
    }
  end

  def status_open?
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
