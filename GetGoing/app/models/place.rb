class Place < ApplicationRecord
  has_many :place_user_relations, dependent: :destroy
  has_many :users, through: :place_user_relations
  has_many :place_post_relations, dependent: :destroy
  has_many :posts, through: :place_post_relations
  has_many :spots, dependent: :destroy

  validates :google_place_id, presence: true
  validate :validate_place_attrs

  reverse_geocoded_by :latitude, :longitude

  def validate_place_attrs
    unless city.present? || state.present? || country.present?
      errors[:base] << "Can\'t be blank"
    end
  end

  def full_name
    [city, state, country].compact.split('').flatten.join(', ')
  end

  def fb_spots(current_user)
    visited_spots = current_user.spots.where(place: self).pluck(:name)
    return nil unless visited_spots.present?
    "(because you visited #{visited_spots.join(', ')})"
  end
end
