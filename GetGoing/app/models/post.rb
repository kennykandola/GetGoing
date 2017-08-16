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
      travel_dates: travel_dates,
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

  def connect_with_places(places_params)
    places_params.keys.each do |place_id|
      existing_place = Place.where(google_place_id: places_params[place_id]['google_place_id']).first

      if existing_place.present? && places_params[place_id]['_destroy'] == '1'
        disconnect_from_existing_place(existing_place)
      elsif existing_place.present? && self.places.exclude?(existing_place)
        connect_with_existing_place(existing_place)
      elsif existing_place.blank?
        connect_with_new_place(places_params[place_id])
      end
    end
    MatchingPlacesSuggestionJob.perform_later(self)
  end

  def connect_with_existing_place(existing_place)
    PlacePostRelation.create(post: self, place: existing_place)
  end

  def connect_with_new_place(places_params)
    new_place = Place.create(city: places_params['city'],
                             state: places_params['state'],
                             country: places_params['country'],
                             google_place_id: places_params['google_place_id'],
                             latitude: places_params['latitude'],
                             longitude: places_params['longitude'])
    PlacePostRelation.create(post: self, place: new_place)
  end

  def disconnect_from_existing_place(existing_place)
    relations = place_post_relations.where(place: existing_place)
    relations.destroy_all
  end
end
