class Place < ApplicationRecord
  has_many :place_user_relations
  has_many :users, through: :place_user_relations

end
