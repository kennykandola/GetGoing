class PostUser < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum role: %i[owner invited_user responder]

  scope :ownerships, -> { where(role: 'owner') }
end
