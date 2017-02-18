class PostsController < ApplicationController



  before_action :set_post, :require_user, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
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
      if @post.save
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

  if @post.claim < 200
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
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :offering, :body, :whos_traveling, :budget, :travel_dates, :destination, :booking_links, :user_id, :claim, :claimed_users)
    end

end



