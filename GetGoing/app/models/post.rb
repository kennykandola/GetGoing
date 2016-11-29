class Post < ActiveRecord::Base


  belongs_to :user

  has_many :responses
  



  validates_presence_of :title
  validates_presence_of :offering



end
