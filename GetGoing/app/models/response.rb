class Response < ApplicationRecord
  belongs_to :post, touch: true # touch allows to track the latest activity on the post with updated_at
  belongs_to :user

  has_many :top_responses
  has_many :booking_links, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum discussion_privacy: [:public_type, :private_type]

  after_save :build_booking_links

  def build_booking_links
    new_booking_links = extract_booking_links

    if booking_links.present? # Response already has booking links which needs to be updated
      update_booking_links(new_booking_links)
    else
      new_booking_links.each(&:save)
    end
  end

  def extract_booking_links
    new_booking_links = []
    links = body.scan(/([a-zA-Z]+)#((?:https?):\/\/[\w\d\/.-\?\&\%\-\#]+)/)

    if links.present?
      links.each do |link_pair|
        url_type = link_pair[0].downcase.singularize
        url = link_pair[1]
        if BookingLink.url_types.include?(url_type)
          new_booking_links << BookingLink.new(url_type: url_type, url: url,
                                               post: post, response: self)
        end
      end
    end
    new_booking_links
  end

  def update_booking_links(possibly_new_booking_links)
    old_booking_links_ids_to_keep = []
    new_booking_links = []

    # remove unmodified booking links from new booking links collection and save new/updated links
    possibly_new_booking_links.delete_if do |new_booking_link|
      same_booking_link = self.booking_links.where(url: new_booking_link.url, url_type: new_booking_link.url_type)
      if same_booking_link.present?
        old_booking_links_ids_to_keep << same_booking_link.first.id # mark old booking link to keep
        true
      else
        new_booking_links << new_booking_link
        false
      end
    end

    # remove old booking links which was modified/removed from response
    booking_links.where.not(id: old_booking_links_ids_to_keep).destroy_all

    # save new booking links
    new_booking_links.each(&:save)
  end
end
