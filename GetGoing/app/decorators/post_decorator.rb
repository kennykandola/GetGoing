class PostDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def current_status
    status ? 'Open' : 'Closed'
  end

  def invitation_url
    h.request.base_url + "/users/invitation/accept?invitation_token=" + invitation_token
  end

end
