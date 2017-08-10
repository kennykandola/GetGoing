class ClaimsExpirationWorker
  include Sidekiq::Worker

  def perform(claim_id)
    claim = Claim.find(claim_id)
    claim.expired! if claim.accepted? # response still not published
  end
end
