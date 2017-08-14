class PostDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def current_status
    status ? 'Open' : 'Closed'
  end

end
