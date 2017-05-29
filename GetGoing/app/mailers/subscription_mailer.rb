class SubscriptionMailer < ApplicationMailer
  default from: "kennykandola89@gmail.com"

  def send_email(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: "Thanks for Subscribing")
  end
end
