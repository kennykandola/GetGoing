class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(recipient_id)
    recipient = User.where(id: recipient_id).first
    if recipient.present?
      notifications_html = ApplicationController.render partial: 'notifications/notifications_component',
                                                        locals: { current_user: recipient }
      ActionCable.server.broadcast "notifications:#{recipient.id}",
                                    notifications_html: notifications_html
    end
  end
end
