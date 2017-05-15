class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :recoverable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :posts
  has_many :responses
  has_many :claims, through: :posts

  has_attached_file :photo

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
