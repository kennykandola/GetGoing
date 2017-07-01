class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(recipient)
    notifications_html = ApplicationController.render partial: 'notifications/notifications_component',
                                                      locals: { current_user: recipient }
    ActionCable.server.broadcast "notifications:#{recipient.id}",
                                  notifications_html: notifications_html
  end
end
