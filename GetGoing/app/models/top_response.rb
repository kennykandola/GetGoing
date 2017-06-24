class TopResponse < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :response


end
