class SubscriptionMailer < ApplicationMailer
  def send_email(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: "Thanks for Subscribing")
  end
end
