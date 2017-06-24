# Model represents user's identity from Google/Facebook
class Identity < ApplicationRecord
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :uid, uniqueness: { scope: :provider, message: "You can register using this provider only once"}

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity.accesstoken = auth.credentials.token
    identity.refreshtoken = auth.credentials.refreshtoken

    # Pulling data from Google/Facebook
    identity.email = auth.info.email
    identity.first_name = auth.extra.raw_info.given_name || auth.extra.raw_info.first_name
    identity.last_name = auth.extra.raw_info.family_name || auth.extra.raw_info.last_name
    identity.birthday = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y') if auth.extra.raw_info.birthday.present?
    identity.age_max = auth.extra.raw_info.age_range.to_h["max"]
    identity.age_min = auth.extra.raw_info.age_range.to_h["min"]
    identity.hometown = auth.extra.raw_info.hometown.name if auth.extra.raw_info.hometown.present?
    identity.location = auth.extra.raw_info.location.name if auth.extra.raw_info.location.present?
    image = auth.info.image
    image += '?type=large' if auth.info.image.present? && auth.info.image.end_with?('picture')
    identity.image = image
    identity.urls = (auth.info.urls || "").to_json

    identity.save
    identity
  end
end
