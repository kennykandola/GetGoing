class BookingLinkDecorator < ApplicationDecorator
  delegate_all

  def upvotes_count
    BookingLinkVotingService.new(booking_link: object).upvotes.count
  end

  def downvotes_count
    BookingLinkVotingService.new(booking_link: object).downvotes.count
  end
end
