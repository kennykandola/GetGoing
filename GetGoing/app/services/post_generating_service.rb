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
    return "My name is #{@user.first_name}, " if @user.present?
    ''
  end

  def traveling_with
    "I'm traveling with #{traveling_with_name} "
  end

  def traveling_with_name
    who_is_traveling = @session[:post][:who_is_traveling]
    who_is_traveling_other = @session[:post][:who_is_traveling_other]
    if who_is_traveling_other.present? && who_is_traveling == 'Other (Describe Below)'
      who_is_traveling_other
    else
      who_is_traveling.downcase if who_is_traveling.present?
    end
  end

  def traveling_to
    places = 'to '
    places << "#{places_names} " if places_names.present?
  end

  def place_name(place)
    place_name = ''
    if place['city'].present?
      place_name = place['city'] +  ', '
    elsif place['region'].present?
      place_name = place['region'] +  ', '
    elsif place['country'].present?
      place_name = place['country'] +  ', '
    end
    place_name
  end

  def places_names
    places = @session[:post][:places]
    places_names = ''
    places.keys.each do |place_id|
      places_names << place_name(places[place_id])
    end
    places_names
  end

  def traveling_on_dates
    travel_start = @session[:post][:travel_start]
    travel_end = @session[:post][:travel_end]
    if travel_start.present? && travel_end.present?
      "in: #{travel_start} - #{travel_end}. "
    else
      ''
    end
  end

  def recommendations
    recommendations = "I'm looking for "
    booking_link_type_ids = @session[:post][:booking_link_type_ids]
    if booking_link_type_ids.present? && booking_link_type_ids != [""]
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
    "Traveling to #{places_names[0..-3]} with #{traveling_with_name} #{traveling_on_dates}"
  end
end
