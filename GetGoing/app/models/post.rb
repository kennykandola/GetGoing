class Post < ActiveRecord::Base



  belongs_to :user

  has_many :responses
  
  has_many :top_responses

  has_many :claims


  serialize :claimed_users, Array




  validates_presence_of :title




end
