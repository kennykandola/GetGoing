class User < ActiveRecord::Base

  has_secure_password

  has_many :posts
  has_many :responses
  has_many :claims, through: :posts

  has_attached_file :photo

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

end
