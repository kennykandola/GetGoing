class PostSavingService
  def initialize(params)
    @session = params[:session]
    @post_params = @session[:post] if @session.present?
    @user = params[:user]
  end

  def initialize_post
    title = @post_params[:title]
    body = @post_params[:body]
    who_is_traveling = @post_params[:who_is_traveling]
    who_is_traveling_other = @post_params[:who_is_traveling_other]
    who_is_traveling = who_is_traveling_other if who_is_traveling_other.present? && who_is_traveling == 'Other (Describe Below)'
    travel_start = Date.strptime(@post_params[:travel_start], "%m/%d/%Y") if @post_params[:travel_start].present?
    travel_end = Date.strptime(@post_params[:travel_end], "%m/%d/%Y") if @post_params[:travel_end].present?
    amenities = @post_params[:amenities]
    accomodation_style = @post_params[:accomodation_style]
    traveler_rating = @post_params[:traveler_rating]
    location_distance = @post_params[:location_distance]
    location_from = @post_params[:location_from]
    min_accomodation_price = @post_params[:min_accomodation_price]
    max_accomodation_price = @post_params[:max_accomodation_price]
    neighborhoods = @post_params[:neighborhoods]
    travel_style = @post_params[:travel_style]
    budget = @post_params[:budget]
    people_total = @post_params[:people_total]
    @post = Post.new(title: title, body: body, who_is_traveling: who_is_traveling,
                     travel_start: travel_start, travel_end: travel_end,
                     amenities: amenities, accomodation_style: accomodation_style,
                     traveler_rating: traveler_rating, location_distance: location_distance,
                     location_from: location_from,
                     min_accomodation_price: min_accomodation_price,
                     max_accomodation_price: max_accomodation_price,
                     neighborhoods: neighborhoods,
                     travel_style: travel_style, budget: budget, people_total: people_total)
    @post.travel_start
  end


  def save_post
    initialize_post
    @post.save
    PostUser.create(user: @user, post: @post, role: 'owner')
    save_places
    save_booking_link_types
    @post
  end

  def save_places

    main_place = @post_params[:main_place]
    places = @post_params[:places]
    post_saving_service = PostPlaceConnectionService.new(post: @post)
    post_saving_service.connect_with_place(main_place) if main_place.present?
    post_saving_service.connect_with_places(places) if places.present?
  end

  def save_booking_link_types
    @post_params[:booking_link_type_ids].each do |link_type_id|
      booking_link_type = BookingLinkType.where(id: link_type_id).first if link_type_id.present?
      @post.booking_link_types << booking_link_type if booking_link_type.present?
    end
  end

end
