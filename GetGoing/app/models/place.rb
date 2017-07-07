class Place < ApplicationRecord
  has_many :place_user_relations, dependent: :destroy
  has_many :users, through: :place_user_relations
  has_many :place_post_relations
  has_many :posts, through: :place_post_relations

  validates :name, :google_place_id, :country, presence: true
end
