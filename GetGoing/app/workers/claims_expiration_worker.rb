class ClaimsExpirationWorker
  include Sidekiq::Worker

  def perform(claim_id)
    claim = Claim.find(claim_id)
    unless claim.responded? # response still not published
      claim.expired!
      NotificationService.new(recipient: claim.user, post: claim.post).claim_expired
    end
  end
end
