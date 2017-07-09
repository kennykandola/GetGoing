class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]

  helper_method :sort_column, :sort_direction

  # GET /posts
  # GET /posts.json
  def all_posts
    search = params[:search].present? ? params[:search] : '*'
    @posts = Post.search(search, aggs: [:places_name], page: params[:page], per_page: 10,
                         order: { sort_column => { order: sort_direction } }
                         )
    @open_posts = Post.search(search, page: params[:page], per_page: 10,
                              aggs: [:places_name],
                              order: { sort_column => { order: sort_direction } },
                              where: { status: true })
    @subscriber = Subscriber.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show

  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save!
        places = post_and_places_params[:places_attributes]
        @post.connect_with_places(places)
        post_params
        User.all.each do |user|
          if user.tippa == true
            PostsMailer.send_diffusion(@message, user).deliver_later
          end
          format.html { redirect_to @post, notice: 'Post was successfully created.'}
          format.json { render :show, status: :created, location: @post }
        end
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
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
  @post = Post.find(params[:post_id])
  @user = User.find(params[:user_id])

  @post.claimed_users.compact!


  @post.increment!(:claim)

  if @post.claim < 7
    @post.claimed_users.push(@user.email)
    @post.save
    redirect_to @post, notice: 'You have successfully claimed this post. You have 8 hours to post a response'
  else
    redirect_to @post, notice: 'Sorry, this post already has enough claims'
  end

end

  def claim_remove
    @post = Post.find(params[:post_id])
    @user = User.find(params[:user_id])

    @post.decrement!(:claim)
    @post.claimed_users.delete(@user.email)
    @post.save
    redirect_to @post, notice: 'Your claim has been removed.'

  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to all_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
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
                                   :claim, :claimed_users, :expired_at, :status,
                                   places_attributes: [:name, :google_place_id,
                                   :country, :_destroy])
    end

    def post_params
      post_and_places_params.except(:places_attributes)
    end

  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

  def upvote_link
    @post = Post.find(params[:id])

  end

end
