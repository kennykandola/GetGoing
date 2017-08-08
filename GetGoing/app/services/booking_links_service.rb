# The service class handles booking links logic
class BookingLinksService
  def initialize(params)
    @post = params[:post]
  end

  def structured_booking_links
    booking_link_types = post_booking_link_types
    structured_booking_links = {}
    booking_link_types.each do |booking_link_type|
      structured_booking_links[booking_link_type.name] = @post.booking_links
                                                              .where(booking_link_type_id: booking_link_type.id)
                                                              .decorate
    end
    structured_booking_links
  end

  def post_booking_link_types
    if @post.booking_link_types.present?
      @post.booking_link_types
    else
      BookingLinkType.all
    end
  end
end
