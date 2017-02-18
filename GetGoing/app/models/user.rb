class User < ActiveRecord::Base

  has_secure_password

  has_many :posts
  has_many :responses
  has_many :claims, through: :posts


end
