# The service handles post claims logic
class ClaimsService
  MAX_ACTIVE_CLAIMS = 3 # include accepted and responded claims

  def initialize(params)
    @post = params[:post]
    @user = params[:user]
    @user_claim = @post.claims.where(user: @user).first if @user.present?
  end

  def claim
    if post_available? && !@user_claim.present?
      create_accepted_claim
    elsif post_available? && @user_claim.present?
      accept_claim
    elsif !post_available? && @user_claim.present?
      waitlist_claim
    elsif !post_available? && !@user_claim.present?
      create_waitlisted_claim
    end
  end

  def create_accepted_claim
    claim = Claim.create(post: @post, user: @user, status: 'accepted')
    ClaimsExpirationWorker.perform_in(3.minutes, claim.id) # WARNING CHANGE MINUTES TO HOURS
    ClaimMessage.claim_accepted
  end

  def create_waitlisted_claim
    Claim.create(post: @post, user: @user, status: 'waitlisted')
    ClaimMessage.claim_waitlisted
  end

  def accept_claim
    @user_claim.accepted!
    ClaimsExpirationWorker.perform_in(3.hours, claim.id)
    ClaimMessage.claim_accepted
  end

  def waitlist_claim
    @user_claim.waitlisted!
    ClaimMessage.claim_waitlisted
  end

  def post_available? # for new claims
    active_claims < MAX_ACTIVE_CLAIMS
  end

  def active_claims
    @post.claims.where(status: %w[accepted responded]).count
  end

  def update_post_availibility
    @post.update_attribute(:claims_available, post_available?)
    send_notifications_to_waitlisted_users
  end

  def cancel_claim # canceled by user
    @user_claim.canceled!
  end

  def response_deleted
    @user_claim.response_deleted!
  end

  def send_notifications_to_waitlisted_users
    NotificationService.new(post: @post).claims_open
  end
end
