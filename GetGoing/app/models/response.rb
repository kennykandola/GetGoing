class Response < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :top_responses
  has_many :booking_links

  after_save :extract_booking_links

  def extract_booking_links
    links = body.scan(/([a-zA-Z]+)#((?:https?):\/\/[\w\d\/.-\?\&\%\-\#]+)/)
    old_booking_links = booking_links
    if links.present?
      links.each do |link_pair|
        url_type = link_pair[0].downcase.singularize
        url = link_pair[1]
        if BookingLink.url_types.include?(url_type)
          booking_link = BookingLink.create(url_type: url_type, url: url, post: post, response: self)
          booking_link.save!
        end
      end
    end
  end
end
