class ActivityDecorator < ApplicationDecorator
  delegate_all
  decorates_association :actor
  decorates_association :acted

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def render_activities
    case action
    when 'new_post'
      action = 'created new post'
      h.render partial: 'activities/activities/activity_uao', locals: { activity: self, action: action }
    when 'new_response'
      action = 'responded to post'
      h.render partial: 'activities/activities/activity_uao', locals: { activity: self, action: action }
    when 'new_public_comment'
      if actionable.response.comments.order('created_at ASC').first.id == actionable.id # check if that comment is first
        action = 'commented on response from'
        h.render partial: 'activities/activities/activity_uao', locals: { activity: self, action: action }
      else
        action = 'replied to comment from'
        h.render partial: 'activities/activities/activity_uao', locals: { activity: self, action: action }
      end
    when 'upvoted_link'
      user1 = actor
      user2 = acted
      action = 'upvoted link recommended by'
      extra = 'from post'
      h.render partial: 'activities/activities/activity_uaueo', locals: { activity: self, action: action, extra: extra, user1: user1, user2: user2 }
    when 'link_was_upvoted'
      user1 = acted
      user2 = actor
      action = 'upvoted link recommended by'
      extra = 'from post'
      h.render partial: 'activities/activities/activity_uaueo', locals: { activity: self, action: action, extra: extra, user1: user1, user2: user2 }
    when 'invited_to_post'
      user1 = acted
      user2 = actor
      action = 'was invited by'
      extra = 'to'
      h.render partial: 'activities/activities/activity_uaueo', locals: { activity: self, action: action, extra: extra, user1: user1, user2: user2 }
    when 'was_invited'
      user1 = actor
      user2 = acted
      action = 'was invited by'
      extra = 'to'
      h.render partial: 'activities/activities/activity_uaueo', locals: { activity: self, action: action, extra: extra, user1: user1, user2: user2 }
    end
  end

  def icon
    h.icon "cogs", class: 'system-activity'
  end

end
