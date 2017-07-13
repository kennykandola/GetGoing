# frozen_string_literal: true

# This class handles importing tagged_places from facebook account
class ImportPlacesService
  def initialize(params)
    @user = params[:user]
    @graph_api = @user.facebook_graph(@user.facebook.accesstoken)
    @places = []
    @spots = []
    @new_place = nil
    @city, @district, @state, @country, @google_place_id = nil
  end

  def import
    all_tagged_places = @graph_api.get_object('me/tagged_places')
    initialize_places(all_tagged_places)
    save_places
  end

  def initialize_places(all_tagged_places)
    all_tagged_places.each do |place|
      facebook_params = {}
      facebook_params[:name] = place['place']['name']
      facebook_params[:fb_id] = place['place']['id']
      facebook_params[:lat] = place['place']['location']['latitude']
      facebook_params[:lng] = place['place']['location']['longitude']
      facebook_params[:city] = place['place']['location']['city']
      facebook_params[:state] = place['place']['location']['state']
      facebook_params[:country] = place['place']['location']['country']
      new_place = get_place_by_coordinates(facebook_params)
      next unless new_place.present?
      @places << new_place
      assign_spots(new_place, facebook_params)
    end
  end

  def assign_spots(new_place, facebook_params)
    new_spot = Spot.new(name: facebook_params[:name], place: new_place,
                        fb_id: facebook_params[:fb_id])
    @spots << new_spot
    new_place.spots << new_spot
  end

  def request_google_place(query)
    Geocoder.search(query).first
  end

  def get_place_by_coordinates(facebook_params)
    google_place = request_google_place(Geocoder.address("#{facebook_params[:lat]},
                                                          #{facebook_params[:lng]}"))
    return nil unless google_place.present?
    set_attributes(google_place.data['address_components'])
    assign_from_fb_params(facebook_params)
    google_place = request_google_place("#{@city} #{@district} #{@state} #{@country}")
    return nil unless google_place.present?
    unless is_city?(google_place.data['types'])
      google_place = request_google_place("#{@city} #{@state} #{@country}")
      return nil unless google_place.present?
    end
    set_attributes(google_place.data['address_components'])
    @google_place_id = google_place.data['place_id']
    if is_sublocality?(google_place.data['types'])
      @city = get_sublocality(google_place.data['address_components'])
    end
    Place.new(city: @city, state: @state, country: @country,
              google_place_id: @google_place_id)
  end

  def assign_from_fb_params(facebook_params)
    @country ||= facebook_params[:country]
    @state ||= facebook_params[:state]
    @city ||= facebook_params[:city]
    @city ||= get_city_from_fb_name(facebook_params[:name], @state, @country)
  end

  def set_attributes(address_components)
    @country = get_country(address_components)
    @district = get_district(address_components)
    @state = get_state(address_components)
    @city = get_city(address_components)
  end

  def get_country(address_components)
    country = address_components.find do |address_component|
      address_component['types'] == %w[country political]
    end
    return nil unless country.present?
    country['long_name']
  end

  def get_state(address_components)
    state = address_components.find do |address_component|
      address_component['types'] == %w[administrative_area_level_1 political]
    end
    return nil unless state.present?
    state['short_name']
  end

  def get_city(address_components)
    city = address_components.find do |address_component|
      is_city?(address_component['types'])
    end
    return nil unless city.present?
    city['long_name']
  end

  def is_city?(types)
    types == %w[locality political] || types == %w[postal_town political] ||
      types == %w[administrative_area_level_3 political] ||
      types == %w[sublocality_level_1 political]
  end

  def get_sublocality(address_components)
    sublocality = address_components.find do |address_component|
      is_sublocality?(address_component['types'])
    end
    return nil unless sublocality.present?
    sublocality['long_name']
  end

  def is_sublocality?(types)
    types == %w[political sublocality sublocality_level_1]
  end

  def get_district(address_components)
    district = address_components.find do |address_component|
      address_component['types'] == %w[administrative_area_level_2 political]
    end
    return nil unless district.present?
    district['long_name']
  end

  def get_city_from_fb_name(name, state, country)
    google_place = request_google_place("#{name} #{state} #{country}")
    return nil unless google_place.present?
    return nil unless is_city?(google_place.data['types'])
    get_city(google_place.data['address_components'])
  end

  def save_places
    @places.each do |new_place|
      existing_place = Place.where(google_place_id: new_place.google_place_id).first
      user_place = @user.places.where(google_place_id: new_place.google_place_id).first
      if existing_place.blank?
        next unless new_place.city.present? && new_place.google_place_id.present?
        new_place.save!
        new_place.spots.each do |spot|
          spot.save!
          SpotUserRelation.create(user: @user, spot: spot)
          @spots.delete(spot)
        end
        @user.places << new_place
      elsif existing_place.present? && user_place.blank?
        @user.places << existing_place
        new_place.spots.each do |spot|
          spot.place = existing_place
          spot.save!
          SpotUserRelation.create(user: @user, spot: spot)
          @spots.delete(spot)
        end
      end
    end
    save_remaining_spots
  end

  def save_remaining_spots
    @spots.each do |spot|
      existing_place = Place.where(google_place_id: spot.place.google_place_id).first
      next unless existing_place.present?
      existing_spot = Spot.where(fb_id: spot.fb_id).first
      if existing_spot.present?
        existing_spot_user_relation = SpotUserRelation.where(spot: existing_spot, user: @user).first
        next if existing_spot_user_relation.present?
        SpotUserRelation.create(user: @user, spot: existing_spot)
      else
        spot.place = existing_place
        spot.save!
        SpotUserRelation.create(user: @user, spot: spot)
      end
    end
  end

  def normalize(name)
    name.chomp.split(',').map(&:strip).uniq.join(', ')
  end

  def add_place(relation_type)
    google_place = @graph_api.get_object("me?fields=#{relation_type}")
    return nil unless google_place[relation_type].present?
    name = normalize(google_place[relation_type]['name'])
    google_place = request_google_place(name)
    address_components = google_place.data['address_components']
    country = get_country(address_components)
    state = get_state(address_components)
    city = get_city(address_components)
    google_place_id = google_place.data['place_id']
    return nil unless city.present? && google_place_id.present?
    @new_place = Place.new(city: city, state: state, country: country,
                           google_place_id: google_place_id)
  end

  def save_hometown
    return nil unless @new_place.present?
    existing_place = Place.where(google_place_id: @new_place.google_place_id).first
    if existing_place.blank?
      @new_place.save!
      @user.hometown = @new_place
    elsif existing_place.present?
      @user.hometown = existing_place
    end
  end

  def save_location
    return nil unless @new_place.present?
    existing_place = Place.where(google_place_id: @new_place.google_place_id).first
    if existing_place.blank?
      @new_place.save!
      @user.location = @new_place
    elsif existing_place.present?
      @user.location = existing_place
    end
  end

  def add_location
    add_place('location')
    save_location
  end

  def add_hometown
    add_place('hometown')
    save_hometown
  end
end
