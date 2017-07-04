class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
  end

  def mark_as_read
    current_user.mark_as_read_all_notifications
    render json: {success: true}
  end
end
