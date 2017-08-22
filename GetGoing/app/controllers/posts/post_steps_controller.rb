class Posts::PostStepsController < ApplicationController
  include Wicked::Wizard

  steps :main_place, :welcome, :destinations, :who_is_traveling, :travel_dates

  def show
    case step
    when :welcome
      remote_step_render(:welcome) if prepare_to_welcome
    when :destinations
      remote_step_render(:destinations) if prepare_to_destinations
    when :who_is_traveling
      remote_step_render(:who_is_traveling) if prepare_to_who_is_traveling
    when :travel_dates
      remote_step_render(:travel_dates) if prepare_to_travel_dates
    end
  end

  def update
    case step
    when :main_place
      remote_step_render(:welcome) if perform_main_place
    when :destinations
      remote_step_render(:who_is_traveling) if perfrom_destionations
    when :who_is_traveling
      remote_step_render(:travel_dates) if perfrom_who_is_traveling
    when :travel_dates
      # session[:post] = session[:post].merge(post_params)
      # @post = Post.new(session[:post])
      # @post.owner = current_user if current_user.present?
      # @post.save
      # redirect_to post_path(@post)
    end
  end

  def cancel_steps
    session.delete(:post)
    session.delete(:places)
    session.delete(:who_is_traveling)
    session.delete(:main_place)
    respond_to :js
  end

  private

  def post_params
    params.require(:post).permit(:title, :who_is_traveling, :main_destinataion_city,
                                 :main_destinataion_country, :who_is_traveling_other,
                                 places_attributes: %i[city google_place_id
                                                       state country latitude
                                                       longitude _destroy])
  end

  def perform_main_place
    prepare_to_welcome
  end

  def perfrom_destionations
    if post_params[:places_attributes].present?
      session[:places] = post_params[:places_attributes]
      @post = Post.new
      prepare_to_who_is_traveling
    end
  end

  def perfrom_who_is_traveling
    if post_params[:who_is_traveling] == PostOptions.who_is_traveling(:other)
      session[:who_is_traveling] = post_params[:who_is_traveling_other]
    else
      session[:who_is_traveling] = post_params[:who_is_traveling]
    end
    prepare_to_travel_dates
  end

  def prepare_to_welcome
    if params[:post].present? && post_params[:places_attributes]['0'][:google_place_id].present?
      @place = Place.new(post_params[:places_attributes]['0'])
      set_initial_place
    elsif session[:main_place].present?
      @place = Place.new(session[:main_place])
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
    session[:main_place] = @place.attributes
    @place = @place.decorate
  end

  def prepare_to_destinations
    @places = []
    @post = Post.new
    if session[:places].present?
      # @places = session[:places]
      session[:places].keys.each do |place_id|
        next if session[:places][place_id]['_destroy'] == '1'
        session[:places][place_id].delete('_destroy')
        @places << Place.new(session[:places][place_id]) if session[:places][place_id][:google_place_id].present?
      end
    else
      @places << Place.new(session[:main_place])
    end
  end

  def prepare_to_who_is_traveling
    @post = Post.new
    if PostOptions.traveling_other?(session[:who_is_traveling])
      @who_is_traveling_other = session[:who_is_traveling]
      @post.who_is_traveling = PostOptions.who_is_traveling(:other)
    else
      @post.who_is_traveling = session[:who_is_traveling]
      @who_is_traveling_other = ''
    end
  end

  def prepare_to_travel_dates
    @post = Post.new
  end

  def remote_step_render(next_step)
    render next_step, format: :js,
                      locals: { post: @post, place: @place }
  end
end
