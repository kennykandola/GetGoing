class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :recoverable and :validatable
  devise :database_authenticatable, :registerable, :omniauthable,
         :rememberable, :trackable

  attr_accessor :current_password

  has_many :posts
  has_many :responses
  has_many :claims, through: :posts
  has_many :identities, dependent: :destroy
  has_many :votes

  enum role: [:simple_user, :moderator, :admin]

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

  def owns_post?(post)
    post.user_id == self.id
  end


end
