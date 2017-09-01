class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized # performs this method if user tries to access feature on which he don't have access

  before_action :configure_permitted_parameters, if: :devise_controller? # allow Devise to receive first_name and last_name from registration form

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  def after_sign_in_path_for(_resource_or_scope)
    "#{user_path(current_user)}#3"
  end
end
