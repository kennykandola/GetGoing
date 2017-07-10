# frozen_string_literal: true
# This class handles importing tagged_places from facebook account
class ImportPlacesService
  def initialize(params)
    @user = params[:user]
    @graph_api = @user.facebook_graph(@user.facebook.accesstoken)
    @google_place_api = GooglePlaces::Client.new(ENV['GOOGLE_MAPS_API'])
  end

  def add_tagged_places
    tagged_places = @graph_api.get_object('me/tagged_places')
    tagged_places.each do |data|
      name = data['place']['name']
      coordinates = data['place']['location']
      new_potential_place = get_potential_place(name, coordinates)
      return nil if new_potential_place.blank?
      existing_place = Place.where(google_place_id: new_potential_place.google_place_id)
      if @user.places.where(google_place_id: new_potential_place.google_place_id).blank? && existing_place.blank?
        new_potential_place.save!
        @user.places << new_potential_place
      elsif @user.places.where(google_place_id: new_potential_place.google_place_id).blank? && existing_place.present?
        @user.places << existing_place.first
      end
    end
  end

  def get_potential_place(name, coordinates=nil)
    name = normalize(name)
    found_places = @google_place_api.spots_by_query(name)
    return nil if found_places.count == 0
    if found_places.count == 1 ||
       (found_places.count > 1 && found_places.first.types == ["locality", "political"]) || # if first place is city
       (found_places.count > 1 && coordinates.blank?) # facebook don't provide coordinates for hometown and current location
      new_place = found_places.first
    elsif found_places.count > 1
      new_place = nearest_place(name, coordinates)
    end
    google_place_id = new_place.place_id
    address = new_place.formatted_address
    name = new_place.name
    Place.new(google_place_id: google_place_id, address: address, name: name)
  end

  def nearest_place(name, coordinates)
    nearest_places = @google_place_api.predictions_by_input(name,
                                           lat: coordinates['latitude'],
                                           lng: coordinates['longitude'],
                                           radius: 5000,
                                           types: 'geocode')
    @google_place_api.spot(nearest_places.first.place_id)
  end

  def normalize(name)
    name.chomp.split(",").map(&:strip).uniq.join(", ")
  end


  def add_hometown
    hometown_data = @graph_api.get_object('me?fields=hometown')
    if hometown_data['hometown'].present?
      name = hometown_data['hometown']['name']
      new_potential_place = get_potential_place(name)
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
      name = location_data['location']['name']
      new_potential_place = get_potential_place(name)
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
