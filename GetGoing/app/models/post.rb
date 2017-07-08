class Post < ApplicationRecord
  belongs_to :user

  has_many :booking_links
  has_many :responses
  has_many :top_responses
  has_many :claims

  has_many :place_post_relations, dependent: :destroy
  has_many :places, through: :place_post_relations
  accepts_nested_attributes_for :places

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

  def connect_with_places(places_params)
    places_params.keys.each do |place_id|
      existing_places = Place.where(google_place_id: places_params[place_id]['google_place_id'])

      if existing_places.present? && places_params[place_id]['_destroy'] == '1'
        disconnect_from_existing_place(existing_places)
      elsif existing_places.present? && self.places.exclude?(existing_places.first)
        connect_with_existing_place(existing_places)
      elsif existing_places.blank?
        connect_with_new_place(places_params[place_id])
      end
    end
  end

  def connect_with_existing_place(existing_places)
    PlacePostRelation.create(post: self, place: existing_places.first)
  end

  def connect_with_new_place(places_params)
    new_place = Place.create(name: places_params['name'],
                 google_place_id: places_params['google_place_id'],
                 country: places_params['country'])
    PlacePostRelation.create(post: self, place: new_place)
  end

  def disconnect_from_existing_place(existing_places)
    relations = place_post_relations.where(place: existing_places.first)
    relations.destroy_all
  end
end
