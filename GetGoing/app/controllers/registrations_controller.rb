class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  def create
    super
    if resource.persisted?
      token = session[:invitation_token]
      if token.present?
        invited_post = Post.where(invitation_token: token).first
        PostUser.create(post: invited_post, user: resource, role: 'invited_user')
        resource.notify_existing_about_invitation
        resource.invitation_accepted
      end
      session.delete(:invitation_token)

      if session[:post].present?
        @post = PostSavingService.new(user: resource, session: session).save_post
        session.delete(:post)
      end

      if resource.tippa
        NotificationService.new(recipient: current_user).tippa_add_places
        WelcomeMailer.welcome_tippa(current_user).deliver_later
      end
    end
  end

  def update_resources(resource, params)
    if resource.enctypted_password.blank?
      resource.email = params[:email] if params[:email]
      if !params[:password].blank? && params[:password] == params[:password_confirmation]
        logger.info "Updating info"
        resource.password = params[:password]
        resource.save
      end
      if resource.valid?
        resource.update_without_password(params)
      end
    else
      resource.update_with_password(params)
    end
  end

  protected

  def after_sign_up_path_for(resource)
    "#{user_path(resource)}#3"
  end
end
