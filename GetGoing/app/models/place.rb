class Place < ApplicationRecord
  has_many :place_user_relations, dependent: :destroy
  has_many :users, through: :place_user_relations
  has_many :place_post_relations, dependent: :destroy
  has_many :posts, through: :place_post_relations

  validates :google_place_id, presence: true
  validate :validate_place_attrs

  def validate_place_attrs
    unless city.present? || state.present? || country.present?
      errors[:base] << "Can\'t be blank"
    end
  end

  def full_name
    [city, state, country].compact.split('').flatten.join(', ')
  end
end
