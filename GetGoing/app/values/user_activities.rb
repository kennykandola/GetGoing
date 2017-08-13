# Value object which represents Activity descriptions
class UserActivities
  def self.describe(action)
    case action
    when 'new_response'
      icon "clock-o"
      local_time_ago(activity.created_at)
    when 'recommended_link_upvoted'

    when 'new_post_with_matching_place'

    when 'new_post_with_matching_nearby_place'

    when 'new_comment_on_response'

    when 'claims_open'

    when 'claim_expired'

    end
  end
end
