# frozen_string_literal: true
# This class handles importing tagged_places from facebook account
class ImportPlacesService
  def initialize(params)
    @user = params[:user]
    @graph_api = @user.facebook_graph(@user.facebook.accesstoken)
    @places = []
    @new_place = nil
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
      facebook_params[:lat] = place['place']['location']['latitude']
      facebook_params[:lng] = place['place']['location']['longitude']
      facebook_params[:city] = place['place']['location']['city']
      facebook_params[:state] = place['place']['location']['state']
      facebook_params[:country] = place['place']['location']['country']

      new_place = get_place_by_coordinates(facebook_params)
      next unless new_place
      @places << new_place
    end
  end

  def request_google_place(query)
    Geocoder.search(query).first
  end

  def get_place_by_coordinates(facebook_params)
    google_place = request_google_place(Geocoder.address("#{facebook_params[:lat]},
                                                          #{facebook_params[:lng]}"))
    return nil unless google_place.present?
    address_components = google_place.data['address_components']
    country = get_country(address_components)
    state = get_state(address_components)
    city = get_city(address_components)
    country ||= facebook_params[:country]
    state ||= facebook_params[:state]
    city ||= facebook_params[:city]
    city ||= get_city_from_fb_name(facebook_params[:name], state, country)
    google_place = request_google_place("#{city} #{state} #{country}")
    return nil unless google_place.present?
    google_place_id = google_place.data['place_id']
    Place.new(city: city, state: state, country: country,
              google_place_id: google_place_id)
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
      address_component['types'] == %w[locality political] ||
        address_component['types'] == %w[postal_town political] ||
        address_component['types'] == %w[administrative_area_level_3 political] ||
        address_component['types'] == %w[sublocality_level_1 political]
    end
    return nil unless city.present?
    city['long_name']
  end

  def get_city_from_fb_name(name, state, country)
    google_place = request_google_place("#{name} #{state} #{country}")
    return nil unless google_place.present?
    return nil unless (google_place.data['types'] == %w[locality political] ||
       google_place.data['types'] == %w[postal_town political] ||
       google_place.data['types'] == %w[administrative_area_level_3 political] ||
       google_place.data['types'] == %w[sublocality_level_1 political])
    get_city(google_place.data['address_components'])
  end

  def save_places
    @places.each do |new_place|
      existing_place = Place.where(google_place_id: new_place.google_place_id).first
      user_place = @user.places.where(google_place_id: new_place.google_place_id).first
      if existing_place.blank?
        new_place.save!
        @user.places << new_place
      elsif existing_place.present? && user_place.blank?
        @user.places << existing_place
      end
    end
  end

    def normalize(name)
      name.chomp.split(",").map(&:strip).uniq.join(", ")
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
      save_place(relation_type)
    end

    def save_place(relation_type)
      existing_place = Place.where(google_place_id: @new_place.google_place_id).first
      user_place = @user.places.references( :place_user_relations )
                               .where(place_user_relations: {relation: relation_type})
      if existing_place.blank?
        @new_place.save!
        PlaceUserRelation.create(user: @user, place: @new_place, relation: relation_type)
      elsif existing_place.present? && user_place.blank?
        PlaceUserRelation.create(user: @user, place: existing_place, relation: relation_type)
      end
    end

    def add_location
      add_place('location')
    end

    def add_hometown
      add_place('hometown')
    end
end
