class WizardStepsService
  def initialize(params = nil)
    @session = params[:session] if params.present?
  end

  def clear_new_post_wizard
    @session.delete(:post)
  end

  def ask_total_people?(who_is_traveling)
    ![:myself, :significant].include? PostOptions.who_is_traveling_options.key(who_is_traveling)
  end

  def ask_accommodations?(booking_link_type_ids)
    booking_link_type_ids.each do |link_type_id|
      booking_link_type = BookingLinkType.where(id: link_type_id).first if link_type_id.present?
      return true if booking_link_type.present? && booking_link_type.is_accommodation == true
    end
    false
  end
end
