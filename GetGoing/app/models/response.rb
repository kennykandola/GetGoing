class Response < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  has_many :top_responses

end
