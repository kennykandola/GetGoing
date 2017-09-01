class UsersMailer < ActionMailer::Base
  default from: "kennykandola89@gmail.com"

  def add_places(user)
    @user = user
    mail(to: user.email, subject: "Hi: #{user.first_name}! Add places you have traveled")
  end
end
