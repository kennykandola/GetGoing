class PostPlaceConnectionService
  def initialize(params)
    @post = params[:post]
  end

  def connect_with_places(places_params)
    places_params.keys.each do |place_id|
      connect_with_place(places_params[place_id])
    end
    MatchingPlacesSuggestionJob.perform_later(@post)
  end

  def connect_with_place(place)
    existing_place = Place.where(google_place_id: place['google_place_id']).first
    if existing_place.present? && place['_destroy'] == '1'
      disconnect_from_existing_place(existing_place)
    elsif existing_place.present? && @post.places.exclude?(existing_place)
      connect_with_existing_place(existing_place)
    elsif existing_place.blank?
      connect_with_new_place(place)
    end
  end

  def connect_with_existing_place(existing_place)
    PlacePostRelation.create(post: @post, place: existing_place)
  end

  def connect_with_new_place(places_params)
    new_place = Place.create(city: places_params['city'],
                             state: places_params['state'],
                             country: places_params['country'],
                             google_place_id: places_params['google_place_id'],
                             latitude: places_params['latitude'],
                             longitude: places_params['longitude'])
    PlacePostRelation.create(post: @post, place: new_place)
  end

  def disconnect_from_existing_place(existing_place)
    relations = @post.place_post_relations.where(place: existing_place)
    relations.destroy_all
  end
end
