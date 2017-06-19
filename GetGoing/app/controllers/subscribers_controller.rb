class SubscribersController < ApplicationController

  def new
    @subscriber = Subscriber.new
  end

  def create
    params.permit!
    @subscriber = Subscriber.create(params[:subscriber])
    @subscriber.save
    SubscriptionMailer.send_email(@subscriber).deliver_later

  end

  private

  def subscribers_params
    params.required(:subscriber).permit(:subscriber)
  end
end
