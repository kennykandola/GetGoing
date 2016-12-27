class Response < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  has_many :top_responses

  validate :check_top_limite

  private
  def check_top_limite
    if self.top && self.post.responses.where(top: true).size >= 3
      errors.add(:top, "most 3 top responses of one post")
    end
  end

end
