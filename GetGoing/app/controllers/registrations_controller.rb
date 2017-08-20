class RegistrationsController < Devise::RegistrationsController
  def create
    super
    token = session[:invitation_token]
    if token.present? && resource.present?
      invited_post = Post.where(invitation_token: token).first
      PostUser.create(post: invited_post, user: resource, role: 'invited_user')
      resource.notify_existing_about_invitation
      resource.invitation_accepted
    end
    # session[:invitation_token] = nil
    session.delete(:invitation_token)
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
end
