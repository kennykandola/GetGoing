class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      ExampleMailer.sample_email(@user).deliver_later
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  def tippa
    @user = User.find(params[:user_id])
    @user.tippa = true
    @user.save
    redirect_to '/profile', notice: 'You will start receiving email notifications for new posts.'
  end

  def show

  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :tippa)
  end

end
