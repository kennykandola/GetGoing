class Spot < ApplicationRecord
  has_many :spot_user_relations, dependent: :destroy
  has_many :users, through: :spot_user_relations
  belongs_to :place
end
