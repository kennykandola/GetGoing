class Post < ApplicationRecord
  belongs_to :user

  has_many :booking_links
  has_many :responses
  has_many :top_responses
  has_many :claims

  serialize :claimed_users, Array

  validates_presence_of :title

end
