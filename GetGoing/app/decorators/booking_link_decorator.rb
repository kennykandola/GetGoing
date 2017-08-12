class BookingLinkDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def upvotes_count
    BookingLinkVotingService.new(booking_link: object).upvotes.count
  end

  def downvotes_count
    BookingLinkVotingService.new(booking_link: object).downvotes.count
  end

  def url_title
    title.present? ? title : url
  end

  def clicked_by_author_at_display
    if clicked_by_author
      h.local_time_ago(clicked_by_author_at)
    else
      'no'
    end
  end
end
