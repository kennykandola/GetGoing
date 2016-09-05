class Post < ActiveRecord::Base
  has_many :responses

  validates_presence_of :title
  validates_presence_of :offering

end
