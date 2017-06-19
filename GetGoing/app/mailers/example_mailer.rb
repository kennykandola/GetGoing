class ExampleMailer < ActionMailer::Base
  default from: "kennykandola89@gmail.com"

  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to TripTippa')
  end
end