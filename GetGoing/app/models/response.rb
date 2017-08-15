class Response < ApplicationRecord
  belongs_to :post, touch: true # touch allows to track the latest activity on the post with updated_at
  belongs_to :user

  has_many :top_responses
  has_many :booking_links, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :activities, as: :actionable, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum discussion_privacy: %i[public_type private_type]

  after_save :build_booking_links
  after_create :track_activity

  def build_booking_links
    new_booking_links = extract_booking_links

    if booking_links.present? # Response already has booking links which needs to be updated
      update_booking_links(new_booking_links)
    else
      new_booking_links.each(&:save) if new_booking_links.present?
    end
  end

  def extract_booking_links
    new_booking_links = []
    links = body.scan(/([a-zA-Z]+)#((?:https?):\/\/[\w\d\/.-\?\&\%\-\#]+)/)
    if links.present?
      links.each do |link_pair|
        url_type = link_pair[0].downcase.singularize
        url = link_pair[1]
        next unless BookingLinkType.all.pluck(:url_type).include?(url_type)
        title = pull_page_title(url)
        next unless title.present?
        booking_link_type_id = BookingLinkType.where(url_type: url_type).first.id
        new_booking_links << BookingLink.new(booking_link_type_id: booking_link_type_id,
                                             url: url, post: post,
                                             response: self, title: title)
      end
    end
    new_booking_links
  end

  def update_booking_links(possibly_new_booking_links)
    old_booking_links_ids_to_keep = []
    new_booking_links = []

    # remove unmodified booking links from new booking links collection and save new/updated links
    possibly_new_booking_links.delete_if do |new_booking_link|
      same_booking_link = booking_links.where(url: new_booking_link.url, booking_link_type_id: new_booking_link.booking_link_type_id)
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
    new_booking_links.each(&:save) if new_booking_links.present?
  end

  def pull_page_title(url)
    agent = Mechanize.new
    agent.user_agent_alias = 'Linux Mozilla'
    begin
      agent.get(url).title
    rescue
      nil
    end
  end

  def track_activity
    Activity.create(actor: user,
                    actionable: self,
                    action: 'new_response')
  end
end
