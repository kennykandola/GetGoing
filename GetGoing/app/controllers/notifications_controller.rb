class NotificationsController < ApplicationController
  def mark_as_read
    current_user.mark_as_read_all_notifications
    render json: {success: true}
  end
end
