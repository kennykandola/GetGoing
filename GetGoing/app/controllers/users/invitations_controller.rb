class Users::InvitationsController < Devise::InvitationsController
  before_action :update_sanitized_params, only: :update

  def edit
    invited_user = User.find_by_invitation_token(params[:invitation_token], true)
    invited_post = Post.where(invitation_token: params[:invitation_token]).first
    if params[:invitation_token] && ( invited_user.present? || invited_post.present?)
      session[:invitation_token] = params[:invitation_token]
    end
    if invited_post.present?
      sign_out send("current_user") if send("user_signed_in?")
      set_minimum_password_length
      redirect_to new_user_registration_path
    else
      super
    end
  end

  def update
    invitation_service = InvitationService.new(invitation_token: update_resource_params[:invitation_token])
    if invitation_service.fb_token?
      redirect_to root_path
    else
      super
    end
  end

  private

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :password, :password_confirmation, :invitation_token])
  end

  def resource_from_invitation_token
    # resource_class.find_by_invitation_token(params[:invitation_token], true)
    super unless Post.where(invitation_token: params[:invitation_token]).first.present?
  end

end
