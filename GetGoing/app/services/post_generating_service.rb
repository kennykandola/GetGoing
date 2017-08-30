class PostGeneratingService
  def initialize(params)
    @session = params[:session]
    @user = params[:user]
  end

  def generate_body
    body = ""
    body << user_name
    body << traveling_with
    body << traveling_to
    body << traveling_on_dates
    body << recommendations
    body << travel_style
    body << budget
  end

  def user_name
    "My name is #{@user.first_name}, " if @user.present?
  end

  def traveling_with
    who_is_traveling = @session[:post][:who_is_traveling]
    who_is_traveling_other = @session[:post][:who_is_traveling_other]
    if who_is_traveling_other.present? && who_is_traveling == 'Other (Describe Below)'
      "I'm traveling with #{who_is_traveling_other} "
    else
      "I'm traveling with #{who_is_traveling.downcase}, " if who_is_traveling.present?
    end
  end

  def traveling_to
    "to #{main_place_name} " if main_place_name.present?
  end

  def main_place_name
    main_place = @session[:post][:main_place]
    main_place_name = ''
    if main_place['city'].present?
      main_place_name = main_place['city']
    elsif main_place['region'].present?
      main_place_name = main_place['region']
    elsif main_place['country'].present?
      main_place_name = main_place['country']
    end
    main_place_name
  end

  def traveling_on_dates
    travel_start = @session[:post][:travel_start]
    travel_end = @session[:post][:travel_end]
    "on dates: #{travel_start} - #{travel_end}. " if travel_start.present? && travel_end.present?
  end

  def recommendations
    recommendations = "I'm looking for "
    booking_link_type_ids = @session[:post][:booking_link_type_ids]
    if booking_link_type_ids.present?
      booking_link_type_ids.each do |link_id|
        booking_link_type = BookingLinkType.where(id: link_id).first
        recommendations << (booking_link_type.name.downcase + ', ') if booking_link_type.present?
      end
      recommendations = recommendations[0..-3] + '. '
      return recommendations
    end
    ''
  end

  def travel_style
    travel_style = @session[:post][:travel_style].downcase
    "My travel style can be described as #{travel_style} " if travel_style.present?
  end

  def budget
    budget = @session[:post][:budget]
    "and I would describe my budget as #{budget}." if budget.present?
  end

  def generate_title
    "Trip to #{main_place_name}"
  end
end
