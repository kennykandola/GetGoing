class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :validatable
  devise :invitable, :database_authenticatable, :registerable, :omniauthable,
         :rememberable, :trackable, :invitable, :recoverable

  attr_accessor :current_password

  searchkick

  def search_data
    {
      email: email,
      first_name: first_name,
      last_name: last_name
    }
  end

  # has_many :posts, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :claims
  has_many :identities, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :activities, foreign_key: :actor_id, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :post_users
  has_many :posts, through: :post_users

  has_many :place_user_relations, dependent: :destroy
  has_many :places, through: :place_user_relations

  has_many :spot_user_relations, dependent: :destroy
  has_many :spots, through: :spot_user_relations

  enum role: [:simple_user, :moderator, :admin]
  enum sex: [:male, :female]

  has_attached_file :photo

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates :email, presence: true, if: :email_required?
  validates :email, uniqueness: true, if: :email_changed?, allow_blank: true
  validates :email, format: {with: Devise.email_regexp, allow_blank: true}, if: :email_changed?

  validates :password, presence: true, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validates :password, length: {within: Devise.password_length}, allow_blank: true

  validates :first_name, length: { minimum: 3, maximum: 100 }
  validates :last_name, length: { minimum: 3, maximum: 100 }

  after_create :send_welcome_email

  def send_welcome_email
    ExampleMailer.sample_email(self).deliver_later
  end

  def password_required?
    return false if email.blank?
    # return false if identities.count > 0
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken )
  end

  def google_oauth2
    identities.where( :provider => "google_oauth2" ).first
  end

  def google_oauth2_client
    if !@google_oauth2_client
      @google_oauth2_client = Google::APIClient.new(:application_name => 'TripTippaDev', :application_version => "1.0.0" )
      @google_oauth2_client.authorization.update_token!({:access_token => google_oauth2.accesstoken, :refresh_token => google_oauth2.refreshtoken})
    end
    @google_oauth2_client
  end

  def facebook_graph(accesstoken)
    @facebook_graph ||= Koala::Facebook::API.new(accesstoken)
  end

  def owns_post?(post)
    post_users.where(post: post).where(role: 'owner').present?
  end

  def owns_response?(response)
    response.user_id == self.id
  end

  def picture_url
    if profile_picture_url.present?
      profile_picture_url
    elsif photo.present?
      photo.url
    else
      ''
    end
  end

  def unread_notifications
    Notification.where(recipient: self).unread
  end

  def last_read_notifications
    Notification.where(recipient: self).read.last(5)
  end

  def mark_as_read_all_notifications
    self.unread_notifications.update_all(read_at: Time.zone.now)
  end

  def member_of_discussion?(response)
    self == response.user || self == response.post.owner
  end

  def current_location_name
    current_location_relation = PlaceUserRelation.where(user: self, relation: "location")
    return nil unless current_location_relation.present?
    place = current_location_relation.first.place
    place.full_name
  end

  def hometown_name
    current_location_relation = PlaceUserRelation.where(user: self, relation: "hometown")
    return nil unless current_location_relation.present?
    place = current_location_relation.first.place
    place.full_name
  end

  def current_location
    PlaceUserRelation.where(user: self, relation: "location").present? ? PlaceUserRelation.where(user: self, relation: "location").first.place : nil
  end

  def hometown
    PlaceUserRelation.where(user: self, relation: "hometown").present? ? PlaceUserRelation.where(user: self, relation: "hometown").first.place : nil
  end

  def location=(place)
    remove_old_location if current_location.present?
    place_user_relations = PlaceUserRelation.where(place: place, user: self)
    if place_user_relations.present?
      place_user_relations.each do |place_user_relation|
        if place_user_relation.traveled?
          place_user_relation.update(relation: 'location')
        elsif place_user_relation.hometown?
          PlaceUserRelation.create(place: place, user: self, relation: 'location')
        end
      end
    else
      PlaceUserRelation.create(place: place, user: self, relation: 'location')
    end
  end

  def remove_old_location
    if traveled_places.where(id: current_location.id).present?
      place_user_relations.where(place: current_location, relation: 'location')
                          .destroy_all
    else
      PlaceUserRelation.where(user: self, relation: 'location')
                       .update_all(relation: 'traveled')
    end
  end

  def hometown=(place)
    remove_old_hometown if hometown.present?
    place_user_relations = PlaceUserRelation.where(place: place, user: self)
    if place_user_relations.present?
      place_user_relations.each do |place_user_relation|
        if place_user_relation.traveled?
          place_user_relation.update(relation: 'hometown')
        elsif place_user_relation.location?
          PlaceUserRelation.create(place: place, user: self, relation: 'hometown')
        end
      end
    else
      PlaceUserRelation.create(place: place, user: self, relation: 'hometown')
    end
  end

  def remove_old_hometown
    if traveled_places.where(id: hometown.id).present?
      place_user_relations.where(place: hometown, relation: 'hometown')
                          .destroy_all
    else
      PlaceUserRelation.where(user: self, relation: 'hometown')
                       .update_all(relation: 'traveled')
    end
  end

  def traveled_places
    places.references( :place_user_relations ).where(place_user_relations: {relation: 'traveled'})
  end

  def all_places
    places.group(:id)
  end

  def owned_posts
    # post_users.ownerships.map(&:post)
    Post.where(id: post_users.ownerships.pluck(:post_id))
  end

  def invited_posts
    # post_users.ownerships.map(&:post)
    Post.where(id: post_users.invitations.pluck(:post_id))
  end
end
