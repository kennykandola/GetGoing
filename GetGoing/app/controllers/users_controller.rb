class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update, :profile, :index, :assign_as_admin, :assign_as_moderator, :assign_as_simple_user]
  before_action :set_users, only: [:assign_as_admin, :assign_as_moderator, :assign_as_simple_user]

  def index
    @users = User.active
    authorize @users
    @users = @users.decorate
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to '/profile', notice: 'Successfully updated.' }
        format.json { render :show, status: :ok, location: @user }

      else
        format.html { render :edit, notice: 'Something wrong.'}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def tippa
    current_user.tippa = params[:tippa]
    if current_user.save && current_user.tippa
      render 'users/tippa_confirmed', format: :js
      NotificationService.new(recipient: current_user).tippa_add_places
      UsersMailer.add_places(current_user).deliver_later
    end
  end

  def tippa_question
    render 'users/tippa_question', format: :js
  end

  def show
    @user = User.find(params[:id]).decorate
    @activities = @user.activities
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 10)
                       .decorate
    @posts = @user.posts.order(created_at: :desc)
                  .paginate(page: params[:page], per_page: 10)
                  .decorate
    @places = @user.all_places
                   .order(created_at: :desc)
                   .paginate(page: params[:page], per_page: 10)
    @ask_question = current_user.sign_in_count == 1 &&
                    current_user.posts.blank? &&
                    current_user.identities.present? &&
                    current_user.tippa.nil?
  end

  def assign_as_admin
    authorize @user
    @user.admin!
    @users = @users.decorate
    respond_to :js
  end

  def assign_as_moderator
    authorize @user
    @user.moderator!
    @users = @users.decorate
    respond_to :js
  end

  def assign_as_simple_user
    authorize @user
    @user.simple_user!
    @users = @users.decorate
    respond_to :js
  end


  def autocomplete_users
  ## Server-side user autocomplete search disabled in order to eliminate network requests
  ## (For now it’s much faster and efficient to load all records into JavaScript and autocomplete there instead of making request to server with each input keypress)
    # render json: User.search(params[:query], {
    #   fields: ["email^5", "first_name", "last_name"],
    #   match: :word_start,
    #   limit: 10,
    #   load: false,
    #   misspellings: {below: 5}
    # }).map { |user| { email: user.email,
    #                   first_name: user.first_name,
    #                   last_name: user.last_name } }
    @users = User.simple_user
    respond_to :json
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :tippa, :score, :photo)
  end

  def set_users
    @user = User.find(params[:id])
    @users = User.all
  end

end
