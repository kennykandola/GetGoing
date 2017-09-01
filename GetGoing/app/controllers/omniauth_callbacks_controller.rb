class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback('facebook')
  end

  def google_oauth2
    generic_callback('google_oauth2')
  end

  # Method is called on every signin/signup with Google/Facebook
  def generic_callback(provider)
    @identity = Identity.find_for_oauth request.env['omniauth.auth']

    @user = @identity.user || User.find_by(email: @identity.email) || current_user
    token = session[:invitation_token]
    if token.present? && @identity.user.blank?
      invited_user = User.find_by_invitation_token(token, true)
      invited_post = Post.where(invitation_token: token).first
      if invited_user.present?
        @user = invited_user
        sync_attributes
        @user.accept_invitation!
      elsif invited_post.present?
        @user = User.create(email: @identity.email || '')
        sync_attributes
        PostUser.create(post: invited_post, user: @user, role: 'invited_user')
        @user.notify_existing_about_invitation
        @user.invitation_accepted
      end
      @identity.update_attribute(:user_id, @user.id)
    end

    if @user.nil?
      @user = User.create(email: @identity.email || '')
      @identity.update_attribute(:user_id, @user.id)
      sync_attributes
    end

    # session[:invitation_token] = nil
    session.delete(:invitation_token)

    if @user.persisted?
      @identity.update_attribute(:user_id, @user.id)
      @user = User.find @user.id
      if session[:post].present?
        @post = PostSavingService.new(user: @user, session: session).save_post
        session.delete(:post)
      end
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']
      "#{user_path(@user)}#3"
    end
  end

  private

  def sync_attributes
    if @user.email.blank? && @identity.email
      @user.update_attribute(:email, @identity.email)
    end

    if @user.first_name.blank? && @identity.first_name
      @user.update_attribute(:first_name, @identity.first_name)
    end

    if @user.last_name.blank? && @identity.last_name
      @user.update_attribute(:last_name, @identity.last_name)
    end

    if @identity.birthday
      age = Date.today.year - @identity.birthday.year
      age -= 1 if Date.today < @identity.birthday + age.years
      @user.update_attribute(:age, age)
    end

    if @identity.gender.present? && @user.sex.blank? && User.sexes.include?(@identity.gender)
      @user.update_attribute(:sex, @identity.gender)
    end

    if @identity.image && @user.profile_picture_url.blank?
      @user.update_attribute(:profile_picture_url, @identity.image)
    end
  end
end
