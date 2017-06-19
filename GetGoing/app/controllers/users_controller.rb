class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      ExampleMailer.sample_email(@user).deliver_later
      session[:user_id] = @user.id
      redirect_to '/posts'
    else
      redirect_to '/signup'
    end
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

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :tippa, :score, :photo)
  end

end
