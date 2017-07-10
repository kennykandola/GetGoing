# frozen_string_literal: true
# This class handles importing tagged_places from facebook account
class ImportPlacesService
  def initialize(params)
    @user = params[:user]
    @graph_api = @user.facebook_graph(@user.facebook.accesstoken)
  end

  def add_tagged_places
    tagged_places = @graph_api.get_object('me/tagged_places')
    tagged_places.each do |data|
      new_potential_place = get_potential_place(data['place']['name'])
      existing_place = Place.where(google_place_id: new_potential_place.google_place_id)
      if @user.places.where(google_place_id: new_potential_place.google_place_id).blank? && existing_place.blank?
        new_potential_place.save!
        @user.places << new_potential_place
      elsif @user.places.where(google_place_id: new_potential_place.google_place_id).blank? && existing_place.present?
        @user.places << existing_place.first
      end
    end
  end

  def get_potential_place(name)
    name = normalize(name)
    google_place_api = GooglePlaces::Client.new(ENV['GOOGLE_MAPS_API'])
    found_places = google_place_api.spots_by_query(name)
    google_place_id = found_places.first.place_id
    address = found_places.first.formatted_address
    name = found_places.first.name
    Place.new(google_place_id: google_place_id, address: address, name: name)
  end

  def normalize(name)
    name.chomp.split(",").map(&:strip).uniq.join(", ")
  end


  def add_hometown
    hometown_data = @graph_api.get_object('me?fields=hometown')
    if hometown_data['hometown'].present?
      new_potential_place = get_potential_place(hometown_data['hometown']['name'])
      existing_place = Place.where(google_place_id: new_potential_place.google_place_id)
      if existing_place.present?
        PlaceUserRelation.create(user: @user, place: existing_place.first, relation: 'hometown')
      elsif existing_place.blank?
        new_potential_place.save!
        PlaceUserRelation.create(user: @user, place: new_potential_place, relation: 'hometown')
      end
    end
  end

  def add_location
    location_data = @graph_api.get_object('me?fields=location')
    if location_data['location'].present?
      new_potential_place = get_potential_place(location_data['location']['name'])
      existing_place = Place.where(google_place_id: new_potential_place.google_place_id)
      if existing_place.present?
        PlaceUserRelation.create(user: @user, place: existing_place.first, relation: 'location')
      elsif existing_place.blank?
        new_potential_place.save!
        PlaceUserRelation.create(user: @user, place: new_potential_place, relation: 'location')
      end
    end
  end

end
