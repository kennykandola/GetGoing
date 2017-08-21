class Posts::PostStepsController < ApplicationController
  include Wicked::Wizard

  steps :main_place, :welcome, :destinations, :who_is_traveling, :travel_dates

  def show
    @post = Post.new

    case step
    when :welcome
    when :destinations
      @places = []
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
    render step, format: :js,
                 locals: { post: @post, places: @places }
    # respond_to do |format|
    #   format.js { render_wizard(@post, formats: 'js') }
    # end
  end

  def update
    case step
    when :main_place
      perform_main_place
    when :destinations
      perfrom_destionations
    when :who_is_traveling
      session[:post] = session[:post].merge(post_params)
      @post = Post.new(session[:post])
      @post.owner = current_user if current_user.present?
      @post.save
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :who_is_traveling, :main_destinataion_city,
                                 :main_destinataion_country,
                                 places_attributes: %i[city google_place_id
                                                       state country latitude
                                                       longitude _destroy])
  end

  def perform_main_place
    google_place_id = post_params[:places_attributes]['0'][:google_place_id]
    if google_place_id.present?
      @place = Place.new(post_params[:places_attributes]['0'])
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
      render next_step, format: :js,
                        locals: { post: @post, place: @place }
    end
  end

  def perfrom_destionations
    if post_params[:places_attributes].present?
      session[:places] = post_params[:places_attributes]
      @post = Post.new
      render next_step, format: :js, locals: { post: @post }
    end
  end
end
