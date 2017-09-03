class WelcomeMailer < ApplicationMailer
  def welcome_user(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to TripTippa')
  end

  def welcome_tippa(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for signing up as an advisor on TripTippa!')
  end
end
