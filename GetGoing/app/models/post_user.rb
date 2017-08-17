class PostUser < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id, message: 'can be connected to the post only once' }

  enum role: %i[owner invited_user responder]

  attribute :email, :string

  before_validation :set_user_id, if: :email?
  after_create :track_activity

  scope :ownerships, -> { where(role: 'owner') }
  scope :invitations, -> { where(role: 'invited_user') }

  def set_user_id
    self.user = User.invite!(email: email)
  end

  def track_activity
    Activity.create(actor: user, actionable: self.post, action: 'new_post') if owner?
  end
end
