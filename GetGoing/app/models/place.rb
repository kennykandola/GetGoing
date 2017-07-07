class Place < ApplicationRecord
  has_many :place_user_relations, dependent: :destroy
  has_many :users, through: :place_user_relations

  validates :name, :google_place_id, :country, presence: true
end
