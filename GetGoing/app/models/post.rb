class Post < ActiveRecord::Base


  belongs_to :user

  has_many :responses
  has_many :tags



  validates_presence_of :title
  validates_presence_of :offering



end
