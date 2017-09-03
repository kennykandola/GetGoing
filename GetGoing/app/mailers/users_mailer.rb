class UsersMailer < ApplicationMailer
  def invite_advisor(user)
    @user = user
    mail(to: user.email, subject: "You've been invited to sign up on TripTippa as an advisor!")
  end
end
