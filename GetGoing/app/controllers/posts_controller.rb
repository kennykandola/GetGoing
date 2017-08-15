class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy new_invitation claim cancel_claim]
  before_action :authenticate_user!, only: %i[show edit update destroy]
  before_action :set_claim_service, only: %i[claim cancel_claim]

  helper_method :sort_column, :sort_direction

  def all_posts
    search = params[:search].present? ? params[:search] : '*'
    @posts = Post.search(search, aggs: [:places_name], page: params[:page], per_page: 50,
                                 order: { sort_column => { order: sort_direction } })
    @open_posts = Post.search(search, page: params[:page], per_page: 50,
                                      aggs: [:places_name],
                                      order: { sort_column => { order: sort_direction } },
                                      where: { status: true })
    if params[:search].present?
      @all_posts_count = @posts.count
      @open_posts_count = @open_posts.count
    else
      @all_posts_count = Post.all.count
      @open_posts_count = Post.status_open.count
    end
    @subscriber = Subscriber.new
  end

  def show
    @structured_booking_links = BookingLinksService.new(post: @post)
                                                   .structured_booking_links
  end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save!
        @post.owner = current_user # creates join record in join table
        places = post_and_places_params[:places_attributes]
        @post.connect_with_places(places)
        User.all.each do |user|
          if user.tippa == true
            PostsMailer.send_diffusion(@message, user).deliver_later
          end
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @post }
        end
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        places = post_and_places_params[:places_attributes]
        @post.connect_with_places(places)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }

      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def claim
    flash[:notice] = @claim_service.claim
    respond_to :js
  end

  def cancel_claim
    flash[:notice] = @claim_service.cancel_claim
    respond_to :js
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to all_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def new_invitation
    @users = User.where.not(id: current_user.id)
    respond_to :js
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_and_places_params
    params.require(:post).permit(:title, :body, :whos_traveling, :structured,
                                 :already_booked, :budget, :travel_dates,
                                 :destination, :booking_links, :user_id,
                                 :claim, :expired_at, :status,
                                 places_attributes: %i[city google_place_id
                                                       state country latitude longitude _destroy])
  end

  def post_params
    post_and_places_params.except(:places_attributes)
  end

  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def upvote_link
    @post = Post.find(params[:id])
  end

  def set_claim_service
    @claim_service = ClaimsService.new(user: current_user, post: @post)
  end
end
