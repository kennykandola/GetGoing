class Posts::PostStepsController < ApplicationController
  include Wicked::Wizard

  steps :main_place, :welcome, :destinations, :who_is_traveling, :people_total,
        :travel_dates, :recommendations, :accommodations, :travel_style, :budget,
        :post_body

  def show
    wizard_steps_service = WizardStepsService.new
    case step
    when :welcome
      remote_step_render(:welcome) if initialize_welcome
    when :destinations
      remote_step_render(:destinations) if initialize_destinations
    when :who_is_traveling
      remote_step_render(:who_is_traveling) if initialize_who_is_traveling
    when :people_total
      if wizard_steps_service.ask_total_people?(session[:post][:who_is_traveling])
        remote_step_render(:people_total) if initialize_people_total
      else
        remote_step_render(:who_is_traveling) if initialize_who_is_traveling
      end
    when :travel_dates
      remote_step_render(:travel_dates) if initialize_travel_dates
    when :recommendations
      remote_step_render(:recommendations) if initialize_recommendations
    when :accommodations
      if wizard_steps_service.ask_accommodations?(session[:post][:booking_link_type_ids])
        remote_step_render(:accommodations) if initialize_accommodations
      else
        remote_step_render(:recommendations) if initialize_recommendations
      end
    when :travel_style
      remote_step_render(:travel_style) if initialize_travel_style
    when :budget
      remote_step_render(:budget) if initialize_budget
    when :post_body
      remote_step_render(:post_body) if initialize_post_body
    end
  end

  def update
    wizard_steps_service = WizardStepsService.new
    case step
    when :main_place
      session[:post] = {}
      remote_step_render(:welcome) if perform_main_place
    when :destinations
      remote_step_render(:who_is_traveling) if perfrom_destionations
    when :who_is_traveling
      if wizard_steps_service.ask_total_people?(post_params[:who_is_traveling])
        remote_step_render(:people_total) if perfrom_who_is_traveling
      else
        remote_step_render(:travel_dates) if perfrom_who_is_traveling && initialize_travel_dates
      end
    when :people_total
      remote_step_render(:travel_dates) if perform_people_total
    when :travel_dates
      remote_step_render(:recommendations) if perfrom_travel_dates
      # session[:post] = session[:post].merge(post_params)
      # @post = Post.new(session[:post])
      # @post.owner = current_user if current_user.present?
      # @post.save
      # redirect_to post_path(@post)
    when :recommendations
      if wizard_steps_service.ask_accommodations?(post_params[:booking_link_type_ids])
        remote_step_render(:accommodations) if perfrom_recommendations
      else
        remote_step_render(:travel_style) if perfrom_recommendations && perfrom_travel_style
      end

    when :accommodations
      remote_step_render(:travel_style) if perfrom_accommodations
    when :travel_style
      remote_step_render(:budget) if perfrom_travel_style
    when :budget
      remote_step_render(:post_body) if perfrom_budget
    when :post_body
      perform_post_body
      if current_user.present?
        @post = PostSavingService.new(user: current_user, session: session).save_post
        finish_wizard
      else
        render_registration
      end
    end
  end

  def finish_wizard
    render :finish_wizard, format: :js,
                      locals: { redirect_url: post_path(@post) }
  end

  def render_registration
    render 'devise/registrations/new', format: :js,
                      locals: { }
  end

  def cancel_steps
    WizardStepsService.new(session: session).clear_new_post_wizard
    respond_to :js
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :who_is_traveling, :main_destinataion_city,
                                 :main_destinataion_country, :who_is_traveling_other,
                                 :travel_start, :travel_end, { booking_link_type_ids: []},
                                 { amenities: [] }, { accomodation_style: []},
                                 :traveler_rating, :location_distance, :location_from,
                                 :min_accomodation_price, :max_accomodation_price,
                                 :neighborhoods,
                                 :travel_style, :budget, :people_total,
                                 places_attributes: %i[city google_place_id
                                                       state country latitude
                                                       longitude _destroy])
  end

  def perform_main_place
    initialize_welcome
  end

  def initialize_welcome
    if params[:post].present? && post_params[:places_attributes]['0'][:google_place_id].present?
      @place = Place.new(post_params[:places_attributes]['0'])
      set_initial_place
    elsif session[:post][:main_place].present?
      @place = Place.new(session[:post][:main_place])
      set_initial_place
    else
      false
    end
  end

  def set_initial_place
    if @place.city.present?
      @place.place_type = 'city'
    elsif @place.state.present?
      @place.place_type = 'region'
    elsif @place.country.present?
      @place.place_type = 'country'
    end
    @post = Post.new
    session[:post][:main_place] = @place.attributes
    @place = @place.decorate
  end

  def perfrom_destionations
    if post_params[:places_attributes].present?
      session[:post][:places] = post_params[:places_attributes]
      @post = Post.new
      initialize_who_is_traveling
    end
  end

  def initialize_destinations
    @places = []
    @post = Post.new
    if session[:post][:places].present?
      # @places = session[:places]
      session[:post][:places].keys.each do |place_id|
        next if session[:post][:places][place_id]['_destroy'] == '1'
        session[:post][:places][place_id].delete('_destroy')
        @places << Place.new(session[:post][:places][place_id]) if session[:post][:places][place_id][:google_place_id].present?
      end
    else
      @places << Place.new(session[:post][:main_place])
    end
  end

  def perfrom_who_is_traveling
    if post_params[:who_is_traveling] == PostOptions.who_is_traveling(:other)
      session[:post][:who_is_traveling] = post_params[:who_is_traveling_other]
    else
      session[:post][:who_is_traveling] = post_params[:who_is_traveling]
    end
    initialize_people_total
  end

  def initialize_who_is_traveling
    @post = Post.new
    if session[:post][:who_is_traveling].present? && PostOptions.traveling_other?(session[:post][:who_is_traveling])
      @who_is_traveling_other = session[:post][:who_is_traveling]
      @post.who_is_traveling = PostOptions.who_is_traveling(:other)
    elsif session[:post][:who_is_traveling].present?
      @post.who_is_traveling = session[:post][:who_is_traveling]
      @who_is_traveling_other = ''
    end
    true
  end

  def initialize_people_total
    @post = Post.new
    @post.people_total = session[:post][:people_total]
    true
  end

  def perform_people_total
    session[:post][:people_total] = post_params[:people_total]
    initialize_travel_dates
  end

  def perfrom_travel_dates
    session[:post][:travel_start] = post_params[:travel_start] if post_params[:travel_start].present?
    session[:post][:travel_end] = post_params[:travel_end]   if post_params[:travel_end].present?
    initialize_recommendations
  end

  def initialize_travel_dates
    @post = Post.new
    @post.travel_start = session[:post][:travel_start] if session[:post][:travel_start].present?
    @post.travel_end = session[:post][:travel_end] if session[:post][:travel_end].present?
    @post
  end

  def perfrom_recommendations
    session[:post][:booking_link_type_ids] = post_params[:booking_link_type_ids] if post_params[:booking_link_type_ids].present?
    session[:post][:booking_link_type_ids]
    initialize_accommodations
  end

  def initialize_recommendations
    @post = Post.new
    @booking_link_type_ids = []
    if session[:post][:booking_link_type_ids].present?
      session[:post][:booking_link_type_ids].each do |link_type|
        blt = BookingLinkType.where(id: link_type).first
        @booking_link_type_ids << blt.id if blt.present?
      end
    end
    @booking_link_types = BookingLinkType.all
  end

  def perfrom_accommodations
    session[:post][:min_accomodation_price] = post_params[:min_accomodation_price]
    session[:post][:max_accomodation_price] = post_params[:max_accomodation_price]
    session[:post][:amenities] = post_params[:amenities]
    session[:post][:location_distance] = post_params[:location_distance]
    session[:post][:location_from] = post_params[:location_from]
    session[:post][:neighborhoods] = post_params[:neighborhoods]
    session[:post][:traveler_rating] = post_params[:traveler_rating]
    session[:post][:accomodation_style] = post_params[:accomodation_style]
    initialize_travel_style
  end

  def initialize_accommodations
    @post = Post.new
    @post.min_accomodation_price = session[:post][:min_accomodation_price]
    @post.max_accomodation_price = session[:post][:max_accomodation_price]
    @post.amenities = session[:post][:amenities] if session[:post][:amenities].present?
    @post.location_distance = session[:post][:location_distance]
    @post.location_from = session[:post][:location_from]
    @post.neighborhoods = session[:post][:neighborhoods]
    @post.traveler_rating = session[:post][:traveler_rating]
    @post.accomodation_style = session[:post][:accomodation_style] if session[:post][:accomodation_style].present?
    true
  end

  def initialize_travel_style
    @post = Post.new
    @post.travel_style = session[:post][:travel_style]
    true
  end

  def perfrom_travel_style
    session[:post][:travel_style] = post_params[:travel_style]
    initialize_budget
  end

  def initialize_budget
    @post = Post.new
    @post.budget = session[:post][:budget]

    true
  end

  def perfrom_budget
    session[:post][:budget] = post_params[:budget]
    initialize_post_body
  end

  def initialize_post_body
    @post = Post.new
    post_generating_service = PostGeneratingService.new(user: current_user, session: session)
    @post.body = post_generating_service.generate_body
    @post.title = post_generating_service.generate_title
    true
  end

  def perform_post_body
    session[:post][:body] = post_params[:body]
    session[:post][:title] = post_params[:title]
  end

  def remote_step_render(next_step)
    render next_step, format: :js,
                      locals: { post: @post, place: @place }
  end
end
