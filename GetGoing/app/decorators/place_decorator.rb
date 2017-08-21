class PlaceDecorator < ApplicationDecorator
  delegate_all


  def advisors_number_from_country
    places = Place.where(country: country)
    matching_suggestions_service = MatchingSuggestionsService.new(places: places)
    advisors = matching_suggestions_service.find_direct_users
    advisors.present? ? advisors.count : 0
  end

  def advisors_number_from_region
    places = Place.where(state: state)
    matching_suggestions_service = MatchingSuggestionsService.new(places: places)
    advisors = matching_suggestions_service.find_direct_users
    advisors.present? ? advisors.count : 0
  end

  def advisors_number_from_city
    matching_suggestions_service = MatchingSuggestionsService.new(place: self)
    matching_suggestions_service.find_users
    direct_users = matching_suggestions_service.direct_users
    nearby_users = matching_suggestions_service.nearby_users
    advisors_number = 0
    advisors_number += direct_users.count if direct_users.present?
    advisors_number += nearby_users.count if nearby_users.present?
    advisors_number
  end

  def advisors_number
    case place_type
    when 'city'
      advisors_number_from_city
    when 'region'
      advisors_number_from_region
    when 'country'
      advisors_number_from_country
    end
  end

  def place_name
    case place_type
    when 'city'
      city
    when 'region'
      state
    when 'country'
      country
    end
  end

end
