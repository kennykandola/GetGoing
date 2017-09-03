# Value object which take part in implementing the logic of user's score
class UserScore
  def self.impact_value(action)
    case action
    when 'downvote'
      -5
    when 'upvote'
      10
    when 'remove'
      -10
    when 'finalize'
      20
    end
  end
end
