class SessionsController < ApplicationController
  def top
  end



  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to '/posts'
    else
      redirect_to 'login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/posts'
  end

end
