class NotificationRelayJob < ApplicationJob
  queue_as :notifications

  def perform(notification)
  end
end
