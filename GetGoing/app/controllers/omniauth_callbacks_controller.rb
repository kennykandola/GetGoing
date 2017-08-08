class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    generic_callback('facebook')
  end

  def google_oauth2
    generic_callback('google_oauth2')
  end

  # Method is called on every signin/signup with Google/Facebook
  def generic_callback(provider)
    @identity = Identity.find_for_oauth request.env["omniauth.auth"]

    @user = @identity.user || User.find_by(email: @identity.email) || current_user

    if @user.nil?
      @user = User.create( email: @identity.email || "" )
      @identity.update_attribute(:user_id, @user.id)
    end

    if @user.email.blank? && @identity.email
      @user.email = @identity.email
    end

    if @user.first_name.blank? && @identity.first_name
      @user.first_name = @identity.first_name
    end

    if @user.last_name.blank? && @identity.last_name
      @user.last_name = @identity.last_name
    end

    if @identity.birthday
      age = Date.today.year - @identity.birthday.year
      age -= 1 if Date.today < @identity.birthday + age.years
      @user.age = age
    end

    if @identity.gender.present? && @user.sex.blank? && User.sexes.include?(@identity.gender)
      @user.sex = @identity.gender
    end

    @user.save

    # @user.update_attribute(:hometown, @identity.hometown) if @identity.hometown
    #
    # @user.update_attribute(:location, @identity.location) if @identity.location

    @user.update_attribute(:profile_picture_url, @identity.image) if @identity.image && @user.profile_picture_url.blank?

    if @user.persisted?
      @identity.update_attribute(:user_id, @user.id)
      @user = User.find @user.id
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end
end
