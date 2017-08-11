# Value object holds claim messages
class ClaimMessage
  def self.claim_accepted
    'You have successfully claimed this post. You have 3 hours to post a response'
  end

  def self.claim_waitlisted
    'Sorry, this post has already reached claims limit. But we will notify you in case if claim will open up.'
  end

  def self.claim_canceled
    'You have successfully canceled your claim on this post'
  end

  def self.claim_should_be_accepted
    'Sorry, but your claim has expired or hasn\'t been accepted yet'
  end

  def self.response_deleted
    'Sorry, but your previous response was deleted'
  end
end
