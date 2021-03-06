class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update, :profile, :index, :assign_as_admin, :assign_as_moderator, :assign_as_simple_user]
  before_action :set_users, only: [:assign_as_admin, :assign_as_moderator, :assign_as_simple_user]

  def index
    @users = User.all
    authorize @users
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
    @user = User.find(params[:user_id])
    @user.tippa = true
    @user.save
    redirect_to '/profile', notice: 'You will start receiving email notifications for new posts.'
  end

  def show
    @user = User
  end

  def assign_as_admin
    authorize @user
    @user.admin!
    respond_to :js
  end

  def assign_as_moderator
    authorize @user
    @user.moderator!
    respond_to :js
  end

  def assign_as_simple_user
    authorize @user
    @user.simple_user!
    respond_to :js
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
